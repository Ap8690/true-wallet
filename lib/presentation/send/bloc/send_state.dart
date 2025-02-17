part of 'send_bloc.dart';

sealed class SendState extends Equatable {
  const SendState();
  
  @override
  List<Object> get props => [];
}

final class SendInitial extends SendState {}

class SendLoading extends SendState {}

class SendError extends SendState {
  final String message;
  const SendError(this.message);

  @override
  List<Object> get props => [message];
}

class GetGasFeeSuccess extends SendState {
  final WalletGasFee gasFee;
  const GetGasFeeSuccess({required this.gasFee});

  @override
  List<Object> get props => [gasFee];
}

class GetGasFeeLoading extends SendState {}

class GetGasFeeFails extends SendState {
  final String message;
  const GetGasFeeFails({required this.message});

  @override
  List<Object> get props => [message];
}

class SendTransactionSuccess extends SendState {
  final String hash;
  const SendTransactionSuccess({required this.hash});

  @override
  List<Object> get props => [hash];
}

class SendTransactionLoading extends SendState {}

class SendTransactionFails extends SendState {
  final String message;
  const SendTransactionFails({required this.message});

  @override
  List<Object> get props => [message];
}

class GetTransactionReceiptSuccess extends SendState {
  final TransactionReceipt? receipt;
  const GetTransactionReceiptSuccess({required this.receipt});

  @override
  List<Object> get props => [receipt ?? 'null'];
}

class GetTransactionReceiptLoading extends SendState {}

class GetTransactionReceiptFails extends SendState {
  final String message;
  const GetTransactionReceiptFails({required this.message});

  @override
  List<Object> get props => [message];
}
