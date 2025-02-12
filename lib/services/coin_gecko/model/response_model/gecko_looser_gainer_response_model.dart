class GeckoGainerLooserResponse {
  final int status;
  final String message;
  final GeckoGainerLooserData data;
  final dynamic errors;

  GeckoGainerLooserResponse({
    required this.status,
    required this.message,
    required this.data,
    this.errors,
  });

  factory GeckoGainerLooserResponse.fromJson(Map<String, dynamic> json) {
    return GeckoGainerLooserResponse(
      status: json['status'],
      message: json['message'],
      data: GeckoGainerLooserData.fromJson(json['data']),
      errors: json['errors'],
    );
  }
}

class GeckoGainerLooserData {
  final List<GeckoToken> topGainers;
  final List<GeckoToken> topLosers;

  GeckoGainerLooserData({
    required this.topGainers,
    required this.topLosers,
  });

  factory GeckoGainerLooserData.fromJson(Map<String, dynamic> json) {
    return GeckoGainerLooserData(
      topGainers: (json['top_gainers'] as List)
          .map((item) => GeckoToken.fromJson(item))
          .toList(),
      topLosers: (json['top_losers'] as List)
          .map((item) => GeckoToken.fromJson(item))
          .toList(),
    );
  }
}

class GeckoToken {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final int? marketCapRank;
  final double usd;
  final double usd24hVol;
  final double usd24hChange;

  GeckoToken({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    this.marketCapRank,
    required this.usd,
    required this.usd24hVol,
    required this.usd24hChange,
  });

  factory GeckoToken.fromJson(Map<String, dynamic> json) {
    return GeckoToken(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      image: json['image'],
      marketCapRank: json['market_cap_rank'],
      usd: json['usd'].toDouble(),
      usd24hVol: json['usd_24h_vol'].toDouble(),
      usd24hChange: json['usd_24h_change'].toDouble(),
    );
  }
}