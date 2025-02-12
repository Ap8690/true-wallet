abstract class AppException implements Exception {
  final String message;
  AppException({required this.message});
}

class ChainException implements AppException {
  @override
  final String message;
  ChainException({required this.message}) : super();
}

class SwapException implements AppException {
  @override
  final String message;
  SwapException({required this.message}) : super();
}

class WalletException implements AppException {
  @override
  final String message;
  WalletException({required this.message}) : super();
}

class ServerException implements AppException {
  @override
  final String message;
  ServerException({required this.message}) : super();
}

class NetworkException implements AppException {
  @override
  final String message;
  NetworkException({required this.message}) : super();
}

class CacheException implements AppException {
  @override
  final String message;
  CacheException({required this.message}) : super();
}

class KyberSwapException implements SwapException {
  @override
  final String message;
  KyberSwapException({required this.message}) : super();
}

class ChatAndPayException implements AppException {
  @override
  final String message;
  ChatAndPayException({required this.message}) : super();
}

class ProfileException implements AppException {
  @override
  final String message;
  ProfileException({required this.message}) : super();
}

class HistoryException implements AppException {
  @override
  final String message;
  HistoryException({required this.message}) : super();
}

class RouterProtocolException implements SwapException {
  @override
  final String message;
  RouterProtocolException({required this.message}) : super();
}

class ChainNetworkException implements AppException {
  @override
  final String message;
  ChainNetworkException({required this.message}) : super();
}

class GroupCreationException implements AppException {
  @override
  final String message;
  GroupCreationException({required this.message}) : super();
}

class DappException implements AppException {
  @override
  final String message;
  DappException({required this.message}) : super();
}

class PaymentException implements AppException {
  @override
  final String message;
  PaymentException({required this.message}) : super();
}

class NotificationException implements AppException {
  @override
  final String message;
  NotificationException({required this.message}) : super();
}

class ReferalException implements AppException {
  @override
  final String message;
  ReferalException({required this.message}) : super();
}