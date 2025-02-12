class GeckoChartData {
  final int status;
  final String message;
  final List<GeckoChartPoint> data;
  final dynamic errors;

  GeckoChartData({
    required this.status,
    required this.message,
    required this.data,
    this.errors,
  });

  factory GeckoChartData.fromJson(Map<String, dynamic> json) {
    return GeckoChartData(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((point) => GeckoChartPoint.fromJson(point)).toList(),
      errors: json['errors'],
    );
  }
}

class GeckoChartPoint {
  final DateTime timestamp;
  final double open;
  final double high;
  final double low;
  final double close;

  GeckoChartPoint({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory GeckoChartPoint.fromJson(List<dynamic> json) {
    return GeckoChartPoint(
      timestamp: DateTime.fromMillisecondsSinceEpoch(json[0] as int),
      open: (json[1] as num).toDouble(),
      high: (json[2] as num).toDouble(),
      low: (json[3] as num).toDouble(),
      close: (json[4] as num).toDouble(),
    );
  }
}