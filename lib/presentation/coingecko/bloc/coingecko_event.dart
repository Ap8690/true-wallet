import 'package:equatable/equatable.dart';

abstract class CoinGeckoEvent extends Equatable {
  const CoinGeckoEvent();

  @override
  List<Object> get props => [];
}

class FetchCoinGeckoCoins extends CoinGeckoEvent {}

class RefreshCoinGeckoCoins extends CoinGeckoEvent {}