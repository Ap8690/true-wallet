import 'dart:convert';
import 'dart:developer';
import 'package:flutter_application_1/services/coin_gecko/model/response_model/coin.dart';
import 'package:flutter_application_1/services/coin_gecko/model/response_model/gecko_chart_data.dart';
import 'package:flutter_application_1/services/coin_gecko/model/response_model/gecko_looser_gainer_response_model.dart';
import 'package:flutter_application_1/utils/constants/app_urls.dart';
import 'package:http/http.dart' as http;

class CoinGeckoService {
  Future<List<Coin>> getCoinsMarkets({
    // required String vsCurrency,
    String? ids,
    String? category,
    String order = 'market_cap_desc',
    int perPage = 100,
    int page = 1,
    bool sparkline = false,
    String? priceChangePercentage,
    String locale = 'en',
  }) async {
    final queryParameters = {
      'vs_currency': "usd",
      // 'order': order,
      // 'per_page': perPage.toString(),
      // 'page': page.toString(),
      // 'sparkline': sparkline.toString(),
      // 'locale': locale,
    };

    if (ids != null) queryParameters['ids'] = ids;
    if (category != null) queryParameters['category'] = category;
    if (priceChangePercentage != null) {
      queryParameters['price_change_percentage'] = priceChangePercentage;
    }

    final uri = Uri.parse('${AppUrls.baseUrl}/ext/tokens')
        .replace(queryParameters: queryParameters);

    try {
      final response = await http.get(
        uri,
        headers: {
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> coinsData = jsonData['data'] as List<dynamic>;
        log("Received ${coinsData.length} coins");
        return coinsData.map((json) => Coin.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load coins data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the CoinGecko API: $e');
    }
  }

  Future<GeckoGainerLooserResponse> getGainersAndLoosers() async {
    final queryParameters = {
      'vs_currency': "usd",
      'top_coins': "300",
    };

    final uri = Uri.parse('${AppUrls.baseUrl}/ext/gainersLosers')
        .replace(queryParameters: queryParameters);

    try {
      final response = await http.get(
        uri,
        headers: {
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        log("Received response: ${response.body}");

        return GeckoGainerLooserResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in getGainersAndLoosers: $e');
      throw Exception('Failed to connect to the API: $e');
    }
  }

  Future<GeckoChartData> getTokenChartData(String tokenId, String days,
      {String interval = "daily"}) async {
    final queryParameters = {
      'id': tokenId,
      // 'interval': interval,
      'days': days,
    };

    final uri = Uri.parse('${AppUrls.baseUrl}/graph')
        .replace(queryParameters: queryParameters);

    try {
      final response = await http.get(
        uri,
        headers: {
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        log("Received chart data response: ${response.body}");

        return GeckoChartData.fromJson(jsonData);
      } else {
        throw Exception('Failed to load chart data: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in getTokenChartData: $e');
      throw Exception('Failed to connect to the API: $e');
    }
  }
}
