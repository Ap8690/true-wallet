import 'package:flutter_application_1/presentation/coingecko/bloc/coingecko_event.dart';
import 'package:flutter_application_1/presentation/coingecko/bloc/coingecko_state.dart';
import 'package:flutter_application_1/services/coin_gecko/coin_gecko_service.dart';
import 'package:flutter_application_1/services/coin_gecko/model/response_model/coin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinGeckoBloc extends Bloc<CoinGeckoEvent, CoinGeckoState> {
  final CoinGeckoService _coinGeckoService;
  List<Coin> coins = []; // Property to store coins as a list
  Map<String, num> coinMap = {}; // New property to store coins as a map

  CoinGeckoBloc(this._coinGeckoService) : super(CoinGeckoInitial()) {
    on<FetchCoinGeckoCoins>(_onFetchCoinGeckoCoins);
    on<RefreshCoinGeckoCoins>(_onRefreshCoinGeckoCoins);
  }

  Future<void> _onFetchCoinGeckoCoins(FetchCoinGeckoCoins event, Emitter<CoinGeckoState> emit) async {
    emit(CoinGeckoLoading());
    try {
      coins = await _coinGeckoService.getCoinsMarkets(
        order: 'market_cap_desc',
        perPage: 100,
        page: 1,
        sparkline: false,
      );
      _updateCoinMap();
      emit(CoinGeckoLoaded(coins));
    } catch (e) {
      emit(CoinGeckoError('Failed to fetch coins: $e'));
    }
  }

  Future<void> _onRefreshCoinGeckoCoins(RefreshCoinGeckoCoins event, Emitter<CoinGeckoState> emit) async {
    try {
      coins = await _coinGeckoService.getCoinsMarkets(
        order: 'market_cap_desc',
        perPage: 100,
        page: 1,
        sparkline: false,
      );
      _updateCoinMap();
      emit(CoinGeckoLoaded(coins));
    } catch (e) {
      emit(CoinGeckoError('Failed to refresh coins: $e'));
    }
  }

  void _updateCoinMap() {
    coinMap = {for (var coin in coins) coin.symbol!.toUpperCase(): coin.currentPrice!};
  }

  List<Coin> getCoins() {
    return coins;
  }

  num? getCoinBySymbol(String symbol) {
    return coinMap[symbol.toUpperCase()];
  }
}