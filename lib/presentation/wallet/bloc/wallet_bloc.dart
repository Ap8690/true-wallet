import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter_application_1/services/wallet/models/chain_data.dart';
import 'package:flutter_application_1/services/wallet/models/chain_metadata.dart';
import 'package:flutter_application_1/services/wallet/models/wallet_model.dart';
import 'package:flutter_application_1/services/wallet/wallet_service.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_application_1/services/secure_storage_service/secure_storage_service.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  ChainMetadata? _previouslySelectedChain;

  ChainMetadata? get previouslySelectedChain => _previouslySelectedChain;

  void updatePreviouslySelectedChain(ChainMetadata chain) {
    _previouslySelectedChain = chain;
  }

  final WalletService service;

  CryptoWallet? wallet;
  CryptoAccount? selectedAccount;

  TokenMetaData selectedToken = ChainData.mainChains.first.tokens.first;
  ChainMetadata selectedChain = ChainData.mainChains.first;
  List<ChainMetadata> chains = ChainData.allChains;

  SecureStorageService storageService = GetIt.I<SecureStorageService>();

  Timer? _balanceTimer;

  WalletBloc(this.service) : super(WalletInitial()) {
    on<WalletEvent>((event, emit) {});

    on<RefreshState>((event, emit) {
      selectedChain = chains.firstWhere(
        (element) => element.id == selectedChain.id,
        orElse: () => ChainData.allChains.first,
      );
      emit(const StateRefreshed());
    });

    on<GetBalance>((event, emit) async {
      if (state is! GetBalanceLoading) {
        emit(const GetBalanceLoading());
      }

      try {
        final address = selectedAccount?.address;
        if (address == null) return;

        final response =
            await service.getCoinBalance(selectedChain.rpc, address);

        await response.fold((error) async {
          if (!error.message.contains("Balance fetch failed")) {
            emit(GetBalanceFail(error.message));
          }
        }, (balance) async {
          final rawWei = balance.getInWei;
          final decimals = selectedToken.decimal;

          final double weiValue =
              rawWei.toString().isEmpty ? 0.0 : double.parse(rawWei.toString());

          final double amount =
              Helpers.fixDecimalPlaces(weiValue / pow(10, decimals));

          selectedToken.balance = amount;
          if (selectedToken.isNative) {
            selectedAccount!.balance = amount;
          }

          await storageService.saveWithPin(
              'walletMeta', jsonEncode(wallet?.toJson()));

          emit(const GetBalanceSuccess());
        });
      } catch (e) {
        if (!e.toString().contains("empty data")) {
          emit(GetBalanceFail(e.toString()));
        }
      }
    });

    on<InitializeWallet>((event, emit) async {
      wallet = event.wallet;
      chains = event.chainList;
      selectedAccount = wallet?.accounts.first;
      selectedChain =
          chains.isNotEmpty ? chains.first : ChainData.allChains.first;

      startPeriodicBalanceCheck();

      add(const GetBalance());

      emit(InitializeWalletSuccess());
    });

    on<ChangeAccount>((event, emit) async {
      selectedAccount = event.account;

      add(const GetBalance());
      emit(AccountChanged(account: event.account));
    });

    on<ChangeToken>((event, emit) async {
      selectedToken = event.token;
      add(const GetBalance());
      emit(TokenChanged(token: event.token));
    });
    String cleanChainId(String chainId) {
      return chainId.contains("eip155") ? chainId.split(":")[1] : chainId;
    }

    on<ChangeChain>((event, emit) async {
      for (var chainData in ChainData.allChains) {
        if (chainData.chainId.contains(cleanChainId(event.chain.chainId))) {
          selectedChain = chainData;
          break;
        } else {
          selectedChain = event.chain;
          break;
        }
      }

      selectedChain = event.chain;
      selectedToken = selectedChain.tokens.isNotEmpty
          ? selectedChain.tokens.first
          : ChainData.allChains.first.tokens.first;
      updatePreviouslySelectedChain(event.chain);
      for (var chainData in ChainData.mainChains) {
        if (chainData.name.contains(event.chain.name)) {
          selectedToken = chainData.tokens.first;
          break;
        }
      }

      add(const GetBalance());
      emit(ChainChanged(chainData: event.chain));
    });

    on<InitiateWalletConnect>((event, emit) async {
      emit(const WalletConnectLoading());
      if (wallet?.accounts.isEmpty ?? false) {
        return emit(const AddAccountFail("Wallet Not found"));
      }
      final response = await service.walletConnectInit(wallet!);
      response.fold((l) {
        emit(WalletConnectFail(l.message));
      }, (r) {
        emit(const WalletConnectInitiated());
      });
    });

    on<PairWallet>((event, emit) async {
      emit(const PairWalletLoading());
      if (wallet?.accounts.isEmpty ?? false) {
        return emit(const PairWalletFail("Wallet Not found"));
      }
      final response = await service.pairWallet(event.uri);
      response.fold((l) {
        emit(PairWalletFail(l.message));
      }, (r) {
        emit(const PairWalletSuccess());
      });
    });

    on<ImportWallet>((event, emit) async {
      emit(const GetWalletLoading());
      final response = await service.importWallet(event.seedPhrase);
      response.fold((l) {
        emit(GetWalletFail(l.message));
      }, (r) {
        wallet = r;
        selectedAccount = wallet?.accounts.first;
        add(const InitiateWalletConnect());
        emit(GetWalletSuccess(wallet: r));
      });
    });

    on<CreateWallet>((event, emit) async {
      print("It's happening");
      emit(const GetWalletLoading());
      final response = await service.createWallet();
      response.fold((l) {
        emit(GetWalletFail(l.message));
      }, (r) {
        wallet = r;
        selectedAccount = wallet?.accounts.first;
        emit(GetWalletSuccess(wallet: r));
      });
    });

    on<ImportAccount>((event, emit) async {
      if (wallet?.accounts.isEmpty ?? false) {
        return emit(const AddAccountFail("Wallet Not found"));
      }

      emit(const AddAccountLoading());

      final response = await service.importAccount(event.privateKey);

      response.fold((l) {
        emit(AddAccountFail(l.message));
      }, (r) async {
        wallet?.accounts.add(r);

        final account = await getAccountFromPrivateKey(r.keyPair.privateKey);

        if (account != null) {
          selectedAccount = account;

          emit(const AddAccountSuccess());
        } else {
          emit(const AddAccountFail("Unable to Account"));
        }
      });
    });

    on<AddAccount>((event, emit) async {
      if (wallet?.accounts.isEmpty ?? false) {
        return emit(const AddAccountFail("Wallet Not found"));
      }

      emit(const AddAccountLoading());

      final response = await service.createAccount(
          wallet?.seedPhrase ?? "", wallet?.accounts.length ?? 0,
          name: event.name);
      response.fold((l) {
        emit(AddAccountFail(l.message));
      }, (r) async {
        wallet?.accounts.add(r);
        selectedAccount = r;
        storageService.saveWithPin('walletMeta', jsonEncode(wallet?.toJson()));
        emit(const AddAccountSuccess());
      });
    });

    on<SignMessage>((event, emit) {
      emit(const SignMessageLoading());
      final response = service.signMessage(
          wallet?.accounts.first.keyPair.privateKey ?? "", event.message);
      response.fold((l) {
        emit(SignMessageFailed(l.message));
      }, (r) {
        emit(SignMessageSuccess(event.message, r));
      });
    });
  }

  Future<CryptoAccount?> getAccountFromPrivateKey(String privateKey) async {
    final response = await service.importAccount(privateKey);
    return response.fold((l) => null, (r) => r);
  }

  void startPeriodicBalanceCheck() {
    _balanceTimer?.cancel();
    _balanceTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      add(const GetBalance());
    });
  }

  @override
  Future<void> close() {
    _balanceTimer?.cancel();
    return super.close();
  }
}
