class TransactionHistory {
  final String hash;
  final String from;
  final String to;
  final String amount;
  final String tokenSymbol;
  final String status;
  final DateTime timestamp;
  final String chainId;
  final String explorerUrl;

  TransactionHistory({
    required this.hash,
    required this.from,
    required this.to,
    required this.amount,
    required this.tokenSymbol,
    required this.status,
    required this.timestamp,
    required this.chainId,
    required this.explorerUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'hash': hash,
      'from': from,
      'to': to,
      'amount': amount,
      'tokenSymbol': tokenSymbol,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'chainId': chainId,
      'explorerUrl': explorerUrl,
    };
  }

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    return TransactionHistory(
      hash: json['hash'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      amount: json['amount'] ?? 0.0,
      tokenSymbol: json['tokenSymbol'] ?? '',
      status: json['status'] ?? '',
      explorerUrl: json['explorerUrl'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toString()),
      chainId: json['chainId'] ?? '',
    );
  }
} 