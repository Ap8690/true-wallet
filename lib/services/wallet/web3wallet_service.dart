import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_application_1/services/wallet/bottom_sheet/i_bottom_sheet_service.dart';
import 'package:flutter_application_1/services/wallet/deep_link_handler.dart';
import 'package:flutter_application_1/services/wallet/i_web3wallet_service.dart';
import 'package:flutter_application_1/services/wallet/key_service/key_service.dart';
import 'package:flutter_application_1/services/wallet/models/chain_data.dart';
import 'package:flutter_application_1/services/wallet/models/wallet_model.dart';
import 'package:flutter_application_1/utils/constants/app_constants.dart';
import 'package:flutter_application_1/utils/eth_utils.dart';
import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:walletconnect_flutter_v2/apis/models/json_rpc_request.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class WalletConnectService extends IWeb3WalletService {
  // final _bottomSheetHandler = GetIt.I<IBottomSheetService>();
  Web3Wallet? _web3Wallet;
  int count = 1;

  static final supportedMethods = {
    'eth_sign',
    'eth_signTransaction',
    'eth_signTypedData',
    'eth_signTypedData_v4',
    'wallet_switchEthereumChain',
    'wallet_addEthereumChain',
  };

  static final requiredMethods = {
    'personal_sign',
    'eth_sendTransaction',
  };

  @override
  void create() async {
    _web3Wallet = Web3Wallet(
      core: Core(
        projectId: AppConstant.projectId,
        // logLevel: LogLevel.debug,
      ),
      metadata: const PairingMetadata(
        name: AppConstant.appName,
        description: AppConstant.appDescription,
        url: AppConstant.websiteUrl,
        icons: [AppConstant.iconsUrl],
        redirect: Redirect(
          native: AppConstant.schema,
          universal: AppConstant.websiteUrl,
        ),
      ),
    );

    // List<CryptoAccount> accountList = wallet.accounts;

    // for (final chainKey in accountList) {
    //   for (final chain in ChainData.allChains) {
    //     _web3Wallet!.registerAccount(
    //       chainId: chain.chainId,
    //       accountAddress: chainKey.address,
    //     );
    //   }
    // }

    // Setup our listeners
    debugPrint('[WALLET] [$runtimeType] create');
    _web3Wallet!.core.pairing.onPairingInvalid.subscribe(_onPairingInvalid);
    _web3Wallet!.core.pairing.onPairingCreate.subscribe(_onPairingCreate);
    _web3Wallet!.onSessionProposal.subscribe(_onSessionProposal);
    _web3Wallet!.onSessionProposalError.subscribe(_onSessionProposalError);
    _web3Wallet!.onAuthRequest.subscribe(_onAuthRequest);
    _web3Wallet!.core.relayClient.onRelayClientError.subscribe(
      _onRelayClientError,
    );
    _web3Wallet!.core.relayClient.onRelayClientMessage.subscribe(
      _onRelayClientMessage,
    );
  }

  @override
  Future<void> init(CryptoWallet wallet) async {
    _web3Wallet = Web3Wallet(
      core: Core(
        projectId: AppConstant.projectId,
        // logLevel: LogLevel.debug,
      ),
      metadata: const PairingMetadata(
        name: AppConstant.appName,
        description: AppConstant.appDescription,
        url: AppConstant.websiteUrl,
        icons: [AppConstant.iconsUrl],
        redirect: Redirect(
          native: AppConstant.schema,
          universal: AppConstant.websiteUrl,
        ),
      ),
    );

    List<CryptoAccount> accountList = wallet.accounts;

    if (accountList.isEmpty) {
      throw "no accounts found";
    }

    for (final chainKey in accountList) {
      for (final chain in ChainData.allChains) {
        _web3Wallet!.registerAccount(
          chainId: chain.chainId,
          accountAddress: chainKey.address,
        );
      }
    }

    // Setup our listeners
    debugPrint('[WALLET] [$runtimeType] create');
    _web3Wallet!.core.pairing.onPairingInvalid.subscribe(_onPairingInvalid);
    _web3Wallet!.core.pairing.onPairingCreate.subscribe(_onPairingCreate);
    _web3Wallet!.onSessionProposal.subscribe(_onSessionProposal);
    _web3Wallet!.onSessionProposalError.subscribe(_onSessionProposalError);
    _web3Wallet!.onAuthRequest.subscribe(_onAuthRequest);
    _web3Wallet!.core.relayClient.onRelayClientError.subscribe(
      _onRelayClientError,
    );
    _web3Wallet!.core.relayClient.onRelayClientMessage.subscribe(
      _onRelayClientMessage,
    );

    debugPrint('[$runtimeType] [WALLET] init');
    await _web3Wallet!.init();
  }

  Future<PairingInfo?> pairWallet(String url) async {
    print(":::::::::::::::::::::::::::>>>>$count");
    count = count + 1;
    Uri uri = Uri.parse(url);
    try {
      PairingInfo info = await _web3Wallet!.pair(uri: uri);
      debugPrint(info.toString());
      return info;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  FutureOr onDispose() {
    debugPrint('[$runtimeType] [WALLET] dispose');
    _web3Wallet!.core.pairing.onPairingInvalid.unsubscribe(_onPairingInvalid);
    _web3Wallet!.core.pairing.onPairingCreate.unsubscribe(_onPairingCreate);
    _web3Wallet!.onSessionProposal.unsubscribe(_onSessionProposal);
    _web3Wallet!.onSessionProposalError.unsubscribe(_onSessionProposalError);
    _web3Wallet!.onAuthRequest.unsubscribe(_onAuthRequest);
    _web3Wallet!.core.relayClient.onRelayClientError.unsubscribe(
      _onRelayClientError,
    );
    _web3Wallet!.core.relayClient.onRelayClientMessage.unsubscribe(
      _onRelayClientMessage,
    );
  }

  @override
  Web3Wallet get web3wallet => _web3Wallet!;

  Map<String, Namespace> _generateNamespaces(
    Map<String, Namespace>? approvedNamespaces,
  ) {
    final constructedNS = Map<String, Namespace>.from(approvedNamespaces ?? {});
    // constructedNS[chainType.name] = constructedNS[chainType.name]!.copyWith(
    //   methods: [
    //     ...constructedNS[chainType.name]!.methods,
    //     ...supportedMethods,
    //   ],
    // );
    return constructedNS;
  }

  void _onSessionProposal(SessionProposalEvent? args) async {
    print("onsessionProposal");
    print("::::::>>>>>>>><<<<<<<>>>>>>");
    debugPrint('[$runtimeType] [WALLET] _onSessionProposal $args');
    if (args != null) {
      // generatedNamespaces is constructed based on registered methods handlers
      // so if you want to handle requests using onSessionRequest event then you would need to manually add that method in the approved namespaces
      final approvedNS = _generateNamespaces(
        args.params.generatedNamespaces!,
      );
      final proposalData = args.params.copyWith(
        generatedNamespaces: approvedNS,
      );
      debugPrint('[WALLET] proposalData $proposalData');
      bool? approved;
      // final approved = await _bottomSheetHandler.queueBottomSheet(
      //   widget: WCRequestWidget(
      //     child: WCConnectionRequestWidget(
      //       wallet: _web3Wallet!,
      //       sessionProposal: WCSessionRequestModel(
      //         request: proposalData,
      //         verifyContext: args.verifyContext,
      //       ),
      //     ),
      //   ),
      // );

      if (approved ?? true) {
        await _web3Wallet!.approveSession(id: args.id, namespaces: approvedNS);
      } else {
        final error = Errors.getSdkError(Errors.USER_REJECTED);
        await _web3Wallet!.rejectSession(id: args.id, reason: error);
        await _web3Wallet!.core.pairing.disconnect(
          topic: args.params.pairingTopic,
        );

        // TODO this should be triggered on _onRelayClientMessage
        final scheme = args.params.proposer.metadata.redirect?.native ?? '';
        DeepLinkHandler.goTo(
          scheme,
          modalTitle: 'Error',
          modalMessage: 'User rejected',
          success: false,
        );
      }
    }
  }

  void _onSessionProposalError(SessionProposalErrorEvent? args) async {
    debugPrint('[$runtimeType] [WALLET] _onSessionProposalError $args');
    DeepLinkHandler.waiting.value = false;
    if (args != null) {
      String errorMessage = args.error.message;
      if (args.error.code == 5100) {
        errorMessage =
            errorMessage.replaceFirst('Requested:', '\n\nRequested:');
        errorMessage =
            errorMessage.replaceFirst('Supported:', '\n\nSupported:');
      }
      GetIt.I<IBottomSheetService>().queueBottomSheet(
        widget: Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(
                Icons.error_outline_sharp,
                color: Colors.red[100],
                size: 80.0,
              ),
              const Text(
                'Error',
              ),
              Text(errorMessage),
            ],
          ),
        ),
      );
    }
  }

  void _onRelayClientMessage(MessageEvent? event) async {
    debugPrint('[$runtimeType] [WALLET] _onRelayClientMessage $event');
    if (event != null) {
      final jsonRpcObject = await EthUtils.decodeMessageEvent(event);
      if (jsonRpcObject is JsonRpcRequest) {
        if (jsonRpcObject.method != 'wc_sessionDelete' &&
            jsonRpcObject.method != 'wc_pairingDelete' &&
            jsonRpcObject.method != 'wc_sessionPing') {
          DeepLinkHandler.waiting.value = true;
        }
      } else {
        final session = _web3Wallet!.sessions.get(event.topic);
        final scheme = session?.peer.metadata.redirect?.native ?? '';
        DeepLinkHandler.goTo(
          scheme,
          modalTitle: jsonRpcObject.result != null ? null : 'Error',
          modalMessage: jsonRpcObject.result != null
              ? null
              : jsonRpcObject.error?.message ?? 'Error',
          success: jsonRpcObject.result != null,
        );
      }
    }
  }

  void _onRelayClientError(ErrorEvent? args) {
    debugPrint('[$runtimeType] [WALLET] _onRelayClientError ${args?.error}');
  }

  void _onPairingInvalid(PairingInvalidEvent? args) {
    debugPrint('[$runtimeType] [WALLET] _onPairingInvalid $args');
  }

  void _onPairingCreate(PairingEvent? args) {
    debugPrint('[$runtimeType] [WALLET] _onPairingCreate $args');
  }

  Future<void> _onAuthRequest(AuthRequest? args) async {
    debugPrint('[$runtimeType] [WALLET] _onAuthRequest $args');

    if (args != null) {
      final chainKeys = GetIt.I<KeyService>().getKeysForChain('eip155:1');
      // Create the message to be signed
      final iss = 'did:pkh:eip155:1:${chainKeys.first.address}';
      bool? auth;

      // final bool? auth = await _bottomSheetHandler.queueBottomSheet(
      //   widget: WCRequestWidget(
      //     child: WCConnectionRequestWidget(
      //       wallet: _web3Wallet!,
      //       authRequest: WCAuthRequestModel(
      //         iss: iss,
      //         request: args,
      //       ),
      //     ),
      //   ),
      // );

      if (auth ?? false) {
        final String message = _web3Wallet!.formatAuthMessage(
          iss: iss,
          cacaoPayload: CacaoRequestPayload.fromPayloadParams(
            args.payloadParams,
          ),
        );

        final String sig = EthSigUtil.signPersonalMessage(
          message: Uint8List.fromList(message.codeUnits),
          privateKey: chainKeys.first.keyPair.privateKey,
        );

        await _web3Wallet!.respondAuthRequest(
          id: args.id,
          iss: iss,
          signature: CacaoSignature(
            t: CacaoSignature.EIP191,
            s: sig,
          ),
        );
      } else {
        await _web3Wallet!.respondAuthRequest(
          id: args.id,
          iss: iss,
          error: Errors.getSdkError(Errors.USER_REJECTED_AUTH),
        );
      }
      DeepLinkHandler.waiting.value = false;
    }
  }
}