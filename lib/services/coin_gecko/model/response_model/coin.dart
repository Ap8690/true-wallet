class Coin {
  final String? id;
  final String? symbol;
  final String? name;
  final String? image;
  final num? currentPrice;
  final num? marketCap;
  final int? marketCapRank;
  final num? fullyDilutedValuation;
  final num? totalVolume;
  final num? high24h;
  final num? low24h;
  final num? priceChange24h;
  final num? priceChangePercentage24h;
  final num? marketCapChange24h;
  final num? marketCapChangePercentage24h;
  final num? circulatingSupply;
  final num? totalSupply;
  final num? maxSupply;
  final num? ath;
  final num? athChangePercentage;
  final DateTime? athDate;
  final num? atl;
  final num? atlChangePercentage;
  final DateTime? atlDate;
  final dynamic roi;
  final DateTime? lastUpdated;

  Coin({
    this.id,
    this.symbol,
    this.name,
    this.image,
    this.currentPrice,
    this.marketCap,
    this.marketCapRank,
    this.fullyDilutedValuation,
    this.totalVolume,
    this.high24h,
    this.low24h,
    this.priceChange24h,
    this.priceChangePercentage24h,
    this.marketCapChange24h,
    this.marketCapChangePercentage24h,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.ath,
    this.athChangePercentage,
    this.athDate,
    this.atl,
    this.atlChangePercentage,
    this.atlDate,
    this.roi,
    this.lastUpdated,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] as String?,
      symbol: json['symbol'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      currentPrice: json['current_price'] as num?,
      marketCap: json['market_cap'] as num?,
      marketCapRank: json['market_cap_rank'] as int?,
      fullyDilutedValuation: json['fully_diluted_valuation'] as num?,
      totalVolume: json['total_volume'] as num?,
      high24h: json['high_24h'] as num?,
      low24h: json['low_24h'] as num?,
      priceChange24h: json['price_change_24h'] as num?,
      priceChangePercentage24h: json['price_change_percentage_24h'] as num?,
      marketCapChange24h: json['market_cap_change_24h'] as num?,
      marketCapChangePercentage24h: json['market_cap_change_percentage_24h'] as num?,
      circulatingSupply: json['circulating_supply'] as num?,
      totalSupply: json['total_supply'] as num?,
      maxSupply: json['max_supply'] as num?,
      ath: json['ath'] as num?,
      athChangePercentage: json['ath_change_percentage'] as num?,
      athDate: json['ath_date'] != null ? DateTime.parse(json['ath_date'] as String) : null,
      atl: json['atl'] as num?,
      atlChangePercentage: json['atl_change_percentage'] as num?,
      atlDate: json['atl_date'] != null ? DateTime.parse(json['atl_date'] as String) : null,
      roi: json['roi'],
      lastUpdated: json['last_updated'] != null ? DateTime.parse(json['last_updated'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'current_price': currentPrice,
      'market_cap': marketCap,
      'market_cap_rank': marketCapRank,
      'fully_diluted_valuation': fullyDilutedValuation,
      'total_volume': totalVolume,
      'high_24h': high24h,
      'low_24h': low24h,
      'price_change_24h': priceChange24h,
      'price_change_percentage_24h': priceChangePercentage24h,
      'market_cap_change_24h': marketCapChange24h,
      'market_cap_change_percentage_24h': marketCapChangePercentage24h,
      'circulating_supply': circulatingSupply,
      'total_supply': totalSupply,
      'max_supply': maxSupply,
      'ath': ath,
      'ath_change_percentage': athChangePercentage,
      'ath_date': athDate?.toIso8601String(),
      'atl': atl,
      'atl_change_percentage': atlChangePercentage,
      'atl_date': atlDate?.toIso8601String(),
      'roi': roi,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }
}