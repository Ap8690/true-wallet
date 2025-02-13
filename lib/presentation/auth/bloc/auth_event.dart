part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class Web3Login extends AuthEvent {
  const Web3Login();

  @override
  List<Object> get props => [];
}
class addFcmToken extends AuthEvent{
  final String fcmToken;
  const addFcmToken(this.fcmToken);
}
class updateFcmToken extends AuthEvent{
  final String userId;
  final String fcmToken;
  const updateFcmToken(this.fcmToken,this.userId);
}


class SetPin extends AuthEvent {
  final String pin;
  final CryptoWallet wallet;
  final List<ChainMetadata> chainList;
  const SetPin(
      {required this.pin, required this.wallet, required this.chainList});

  @override
  List<Object> get props => [];
}

class VerifyPin extends AuthEvent {
  final String pin;
  const VerifyPin(this.pin);

  @override
  List<Object> get props => [];
}
