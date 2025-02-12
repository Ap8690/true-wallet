part of 'wallet_bloc.dart';

sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

final class InitializeWallet extends WalletEvent {
  final CryptoWallet wallet;
  final List<ChainMetadata> chainList;
  const InitializeWallet({required this.wallet, required this.chainList});
}

final class RefreshState extends WalletEvent {}

final class CreateWallet extends WalletEvent {}

final class ChangeAccount extends WalletEvent {
  final CryptoAccount account;
  const ChangeAccount({required this.account});
}

final class ChangeChain extends WalletEvent {
  final ChainMetadata chain;
  const ChangeChain({required this.chain});
}

final class ChangeToken extends WalletEvent {
  final TokenMetaData token;
  const ChangeToken({required this.token});
}

final class GetBalance extends WalletEvent {
  const GetBalance();
}

final class ImportWallet extends WalletEvent {
  final String seedPhrase;
  const ImportWallet({required this.seedPhrase});
}

final class PairWallet extends WalletEvent {
  final String uri;
  const PairWallet({required this.uri});
}

final class AddAccount extends WalletEvent {
  final String? name;
  const AddAccount({this.name});
}

final class ImportAccount extends WalletEvent {
  final String privateKey;
  const ImportAccount({required this.privateKey});
}

final class InitiateWalletConnect extends WalletEvent {
  const InitiateWalletConnect();
}

final class SignMessage extends WalletEvent {
  final String message;
  const SignMessage(this.message);
}
