part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class SetPinSuccess extends AuthState {
  const SetPinSuccess();
}

class SetPinLoading extends AuthState {
  const SetPinLoading();
  @override
  List<Object> get props => [];
}

class SetPinFailure extends AuthState {
  final String message;
  const SetPinFailure(this.message);
}

class VerifyPinSuccess extends AuthState {
  final String walletMetaString;
  final String chainMetaString;
  const VerifyPinSuccess(
      {required this.walletMetaString, required this.chainMetaString});
}

class VerifyPinLoading extends AuthState {
  const VerifyPinLoading();
  @override
  List<Object> get props => [];
}

class VerifyPinFailure extends AuthState {
  final String message;
  const VerifyPinFailure(this.message);
}
