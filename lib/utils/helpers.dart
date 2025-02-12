import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:web3dart/web3dart.dart';

import '../core/exceptions/exceptions.dart';
import '../core/network/http_exceptions.dart';
import '../core/network/http_response.dart';
import '../services/sharedpref/preference_service.dart';

class Helpers {
  static GetIt getIt = GetIt.I;
  static PreferenceService preferenceService = getIt<PreferenceService>();
  static Future<bool> checkLogin() async {
    String? token = preferenceService.accessToken;
    if (token == null) {
      return false;
    }
    return true;
  }

  static BigInt ethToWei(double eth) {
    // 1 ETH = 1e18 Wei
    return BigInt.from(eth * 1e18);
  }

  static double weiToEth(BigInt wei) {
    // 1 Wei = 1e-18 ETH
    return wei.toDouble() / 1e18;
  }

  static BigInt hexToInt(String hex) {
    return BigInt.parse(strip0x(hex), radix: 16);
  }

  static String strip0x(String hex) {
    if (hex.startsWith('0x')) return hex.substring(2);
    return hex;
  }

  static double fixDecimalPlaces(double? number, {int decimal = 6}) {
    return double.parse(number?.toStringAsFixed(decimal) ?? "0.00");
  }

  static String decimalString(double? number, {int decimal = 6}) {
    double smallestAllowed = 1 / double.parse(pow(10, 6).toString());
    if (number != null && number < smallestAllowed) {
      return "<$smallestAllowed";
    }
    return number?.toStringAsFixed(decimal) ?? "0.00";
  }

  static bool isValidEthereumAddress(String address) {
    try {
      EthereumAddress.fromHex(address);
      return true;
    } catch (e) {
      return false;
    }
  }

  static String formatLongString(String input) {
    if (input.length <= 10) {
      return input;
    } else {
      String firstPart = input.substring(0, 7);
      String lastPart = input.substring(input.length - 5);
      return '$firstPart...$lastPart';
    }
  }

  static int parseInt(dynamic value) =>
      int.tryParse(value?.toString() ?? "0") ?? 0;

  static double parseDouble(dynamic value) =>
      double.tryParse(value?.toString() ?? "0.0") ?? 0.0;

  static AppException getExceptionFromCode(NetworkResponse networkResponse) {
    switch (networkResponse.statusCode) {
      case 400:
        return BadRequestException(
            statusCode: networkResponse.statusCode,
            message: networkResponse.message);
      case 401:
        if (networkResponse.errors?.code == 10007) {
          // logout();
        } else {
          // completeLogout();
        }
        return CustomException(
            message: networkResponse.message,
            code: networkResponse.errors?.code ?? 0);
      case 440:
        return SessionExpiredException(
            statusCode: networkResponse.statusCode,
            message: networkResponse.message);
      case 422:
        return ValidationException(
            statusCode: networkResponse.statusCode,
            message: networkResponse.message);
      case 410:
        return NetworkException(message: networkResponse.message);
      case 500:
        return UnknownException(
            statusCode: networkResponse.statusCode,
            message: networkResponse.message);
      default:
        return UnknownException(
            statusCode: networkResponse.statusCode,
            message: networkResponse.message);
    }
  }
}
