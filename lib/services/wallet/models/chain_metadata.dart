
import 'package:hive_flutter/hive_flutter.dart';
part 'chain_metadata.g.dart';

@HiveType(typeId: 7)
class ChainMetadata {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String chainId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String? logo;

  @HiveField(4)
  final bool isTestnet;

  @HiveField(5)
  final String rpc;

  @HiveField(6)
  final bool isDefault;

  @HiveField(7)
  final String symbol;

  @HiveField(8)
  double balance;

  @HiveField(9)
  final List<TokenMetaData> tokens;

  @HiveField(10)
  String? explorerUrl;

  ChainMetadata({
    required this.id,
    this.balance = 0,
    this.logo,
    this.isDefault = false,
    required this.symbol,
    required this.chainId,
    required this.name,
    required this.tokens,
    this.isTestnet = false,
    required this.rpc,
    this.explorerUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chainId': chainId,
      'name': name,
      'isDefault': isDefault,
      'isTestnet': isTestnet,
      'logo': logo,
      'rpc': rpc,
      'symbol': symbol,
      'balance': balance,
      'tokens': tokens.map((token) => token.toJson()).toList(),
      "blockExplorerUrls": explorerUrl,
      "explorerUrl": explorerUrl
    };
  }

  factory ChainMetadata.fromJson(Map<String, dynamic> json) {
    return ChainMetadata(
      id: json['id'],
      chainId: json['chainId'],
      name: json['name'],
      logo: json['logo'],
      isDefault: json['isDefault'],
      isTestnet: json['isTestnet'] ?? false,
      rpc: json['rpc'] ?? "",
      symbol: json['symbol'],
      balance: json['balance'] ?? 0,
      tokens: (json['tokens'] as List<dynamic>)
          .map((tokenJson) => TokenMetaData.fromJson(tokenJson))
          .toList(),
      explorerUrl: json['explorerUrl'] ?? json["blockExplorerUrls"] ?? "",
    );
  }

  static List<ChainMetadata> fromJsonList(json) {
    return List.generate(
        json.length, (index) => ChainMetadata.fromJson(json[index])).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<ChainMetadata> chainList) {
    return List.generate(
        chainList.length, (index) => chainList[index].toJson());
  }
}

@HiveType(typeId: 8)
class TokenMetaData {
  @HiveField(0)
  final String name;

  @HiveField(1)
  double balance;

  @HiveField(2)
  final bool isNative;

  @HiveField(3)
  final String symbol;

  @HiveField(4)
  final int decimal;

  @HiveField(5)
  final String contract;

  @HiveField(6)
  String? logo;

  @HiveField(7)
  double usdBalance;

  @HiveField(8)
  String? coinKey;

  TokenMetaData({
    this.balance = 0.0,
    this.usdBalance = 0.0,
    this.isNative = false,
    this.logo,
    this.coinKey,
    required this.contract,
    required this.name,
    required this.symbol,
    required this.decimal,
  });

  TokenMetaData copyWith({
    String? name,
    double? balance,
    bool? isNative,
    String? symbol,
    int? decimal,
    String? contract,
    String? logo,
    double? usdBalance,
    String? coinKey,
  }) {
    return TokenMetaData(
      name: name ?? this.name,
      balance: balance ?? this.balance,
      isNative: isNative ?? this.isNative,
      symbol: symbol ?? this.symbol,
      decimal: decimal ?? this.decimal,
      contract: contract ?? this.contract,
      logo: logo ?? this.logo,
      usdBalance: usdBalance ?? this.usdBalance,
      coinKey: coinKey ?? this.coinKey,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'balance': balance,
      'isNative': isNative,
      'logo': logo,
      'symbol': symbol,
      'decimal': decimal,
      'contract': contract,
      'coinKey': coinKey,
      'usdBalance': usdBalance,
    };
  }

  factory TokenMetaData.fromJson(Map<String, dynamic> json) {
    return TokenMetaData(
      name: json['name'],
      balance: json['balance'] ?? 0.0,
      isNative: json['isNative'] ?? false,
      symbol: json['symbol'],
      logo: json['logo'],
      decimal: json['decimal'],
      contract: json['contract'],
      coinKey: json['coinKey'],
      usdBalance: json['usdBalance'] ?? 0.0,
    );
  }
}
