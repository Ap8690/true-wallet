part of 'wallet_bloc.dart';

sealed class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

final class WalletInitial extends WalletState {}

final class AccountChanged extends WalletState {
  final CryptoAccount account;
  @override
  List<Object> get props => [DateTime.now().microsecondsSinceEpoch];
  const AccountChanged({required this.account});
}

final class ChainChanged extends WalletState {
  final ChainMetadata chainData;
  @override
  List<Object> get props => [DateTime.now().microsecondsSinceEpoch];
  const ChainChanged({required this.chainData});
}

final class TokenChanged extends WalletState {
  final TokenMetaData token;
  @override
  List<Object> get props => [DateTime.now().microsecondsSinceEpoch];
  const TokenChanged({required this.token});
}

final class GetWalletSuccess extends WalletState {
  final CryptoWallet wallet;
  const GetWalletSuccess({required this.wallet});
}

final class GetWalletFail extends WalletState {
  final String message;
  const GetWalletFail(this.message);
}

final class GetWalletLoading extends WalletState {
  const GetWalletLoading();
}

final class AddAccountSuccess extends WalletState {
  const AddAccountSuccess();
}

final class AddAccountFail extends WalletState {
  final String message;
  const AddAccountFail(this.message);
}

final class AddAccountLoading extends WalletState {
  const AddAccountLoading();
}

final class SignMessageSuccess extends WalletState {
  final String message;
  final String signature;
  const SignMessageSuccess(this.message, this.signature);
}

final class SignMessageFailed extends WalletState {
  final String message;
  const SignMessageFailed(this.message);
}

final class SignMessageLoading extends WalletState {
  const SignMessageLoading();
}

final class WalletConnectInitiated extends WalletState {
  const WalletConnectInitiated();
}

final class WalletConnectFail extends WalletState {
  final String message;
  const WalletConnectFail(this.message);
}

final class WalletConnectLoading extends WalletState {
  const WalletConnectLoading();
}

final class PairWalletSuccess extends WalletState {
  const PairWalletSuccess();
}

final class PairWalletFail extends WalletState {
  final String message;

  const PairWalletFail(this.message);
}

final class PairWalletLoading extends WalletState {
  const PairWalletLoading();
}

final class StateRefreshed extends WalletState {
  @override
  List<Object> get props => [DateTime.now().microsecondsSinceEpoch];
  const StateRefreshed();
}

final class GetBalanceSuccess extends WalletState {
  const GetBalanceSuccess();
}

final class GetBalanceFail extends WalletState {
  final String message;
  const GetBalanceFail(this.message);
}

final class GetBalanceLoading extends WalletState {
  const GetBalanceLoading();
}

final class InitializeWalletSuccess extends WalletState {}

final class InitializeWalletFails extends WalletState {
  final String message;
  const InitializeWalletFails({required this.message});
}
