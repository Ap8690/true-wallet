part of 'send_bloc.dart';

sealed class SendEvent extends Equatable {
  const SendEvent();

  @override
  List<Object> get props => [];
}

class GetGasFee extends SendEvent {
  final bool isNative;
  final String rpc;
  final int decimal;
  final EthereumAddress sender, receiver;
  final BigInt value;
  const GetGasFee(
      {this.isNative = true,
      required this.rpc,
      required this.decimal,
      required this.sender,
      required this.receiver,
      required this.value});

  @override
  List<Object> get props => [isNative, rpc];
}

class SendTransaction extends SendEvent {
  final ChainMetadata chain;
  final TokenMetaData token;
  final Transaction transaction;
  final Credentials credential;
  final bool isNative;
  final String explorerUrl;
  const SendTransaction(
      {required this.chain,
      required this.token,
      required this.transaction,
      required this.credential,
      required this.isNative,
      required this.explorerUrl});

  @override
  List<Object> get props => [chain, token, transaction, credential];
}

class GetTransactionReceipt extends SendEvent {
  final String hash;
  final String rpc;
  const GetTransactionReceipt({required this.hash, required this.rpc});

  @override
  List<Object> get props => [hash, rpc];
}
