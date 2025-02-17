import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_application_1/services/send/models/wallet_gas_fees.dart';
import 'package:flutter_application_1/services/send/send_service.dart';
import 'package:flutter_application_1/services/wallet/models/chain_metadata.dart';
import 'package:web3dart/web3dart.dart';

part 'send_event.dart';
part 'send_state.dart';

class SendBloc extends Bloc<SendEvent, SendState> {
  final SendService sendService;
  final WalletBloc walletBloc;
  SendBloc(
    this.sendService,
    this.walletBloc,) : super(SendInitial()) {
    on<GetGasFee>(_onGetGasFee);
    on<SendTransaction>(_onSendTransaction);
    on<GetTransactionReceipt>(_onGetTransactionReceipt);
  }

  Future<void> _onGetGasFee(GetGasFee event, Emitter<SendState> emit) async {
    emit(GetGasFeeLoading());
    final response = await sendService.getGasFee(
      value: event.value,
      receiver: event.receiver,
      sender: EthereumAddress.fromHex(walletBloc.selectedAccount!.address),
      event.rpc,
      event.decimal,
      isNative: event.isNative,
    );
    response.fold(
      (l) => emit(GetGasFeeFails(message: l.message)),
      (r) => emit(GetGasFeeSuccess(gasFee: r)),
    );
  }

  Future<void> _onSendTransaction(
      SendTransaction event, Emitter<SendState> emit) async {
    emit(SendTransactionLoading());
    final response = await sendService.sendTransaction(
        explorerUrl: event.explorerUrl,
        chain: event.chain,
        credentials: event.credential,
        token: event.token,
        transaction: event.transaction,
        isNative: event.isNative);
    response.fold(
      (l) => emit(SendTransactionFails(message: l.message)),
      (r) => emit(SendTransactionSuccess(hash: r)),
    );
  }

  Future<void> _onGetTransactionReceipt(
      GetTransactionReceipt event, Emitter<SendState> emit) async {
    emit(GetTransactionReceiptLoading());
    final response =
        await sendService.getTransaction(rpc: event.rpc, hash: event.hash);
    response.fold(
      (l) => emit(GetTransactionReceiptFails(message: l.message)),
      (r) => emit(GetTransactionReceiptSuccess(receipt: r)),
    );
  }
}

