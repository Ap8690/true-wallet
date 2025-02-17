
import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/exceptions/exceptions.dart';
import 'package:flutter_application_1/core/network/http_client.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class NetworksService {
  late MyHttpClient httpClient;

  NetworksService() {
    httpClient = GetIt.I<MyHttpClient>();
  }

  Future<Either<AppException, String>> getChainId(String rpc) async {
    try {
      final client = Web3Client(rpc, Client());
      final chainId = (await client.getChainId()).toString();
      return right(chainId);
    } catch (e) {
      return left(ChainException(
          message: "Could not fetch chain ID. Is your RPC URL correct?"));
    }
  }
}
