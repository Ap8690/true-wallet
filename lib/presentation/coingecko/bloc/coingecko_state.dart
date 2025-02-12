import 'package:flutter_application_1/services/coin_gecko/model/response_model/coin.dart';
import 'package:equatable/equatable.dart';

abstract class CoinGeckoState extends Equatable {
  const CoinGeckoState();
  
  @override
  List<Object> get props => [];
}

class CoinGeckoInitial extends CoinGeckoState {}

class CoinGeckoLoading extends CoinGeckoState {}

class CoinGeckoLoaded extends CoinGeckoState {
  final List<Coin> coins;

  const CoinGeckoLoaded(this.coins);

  @override
  List<Object> get props => [coins];
}

class CoinGeckoError extends CoinGeckoState {
  final String message;

  const CoinGeckoError(this.message);

  @override
  List<Object> get props => [message];
}