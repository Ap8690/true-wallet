import 'dart:convert';
import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter_application_1/core/exceptions/exceptions.dart';
import 'package:flutter_application_1/core/network/http_client.dart';
import 'package:flutter_application_1/services/wallet/key_service/key_service.dart';
import 'package:flutter_application_1/services/wallet/models/wallet_model.dart';
import 'package:flutter_application_1/services/wallet/web3wallet_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart' show rootBundle;

class WalletService {
  late KeyService keyService;
  final getIt = GetIt.I;
  late MyHttpClient myHttpClient;
  late WalletConnectService web3walletService;

  WalletService() {
    myHttpClient = getIt<MyHttpClient>();
    web3walletService = getIt<WalletConnectService>();
    keyService = getIt<KeyService>();
  }

  Future<Either<AppException, CryptoWallet>> createWallet() async {
    try {
      return right(await keyService.createWallet());
    } catch (e) {
      return left(WalletException(message: e.toString()));
    }
  }

  Future<Either<AppException, CryptoWallet>> importWallet(
      String seedPhrase) async {
    try {
      final wallet = await keyService.importWallet(seedPhrase, count: 1);

      return right(wallet);
    } catch (e) {
      return left(WalletException(message: e.toString()));
    }
  }

  Future<Either<AppException, EtherAmount>> getTokenBalance(
      String rpc, String add, String contractAddress) async {
    try {
      final address = EthereumAddress.fromHex(add);
      String abiCode = await rootBundle.loadString('assets/abi/erc20.json');

      final contract = DeployedContract(
          ContractAbi.fromJson(abiCode, 'Erc20Token'),
          EthereumAddress.fromHex(contractAddress));

      final client = Web3Client(rpc, Client());

      final balance = await client.call(
          contract: contract,
          function: contract.function('balanceOf'),
          params: [address]);

      debugPrint(balance.toString());

      return right(EtherAmount.fromBigInt(EtherUnit.wei, balance.first));
    } catch (e) {
      return left(WalletException(message: e.toString()));
    }
  }

  Future<Either<AppException, EtherAmount>> getCoinBalance(
      String rpc, String add) async {
    try {
      final address = EthereumAddress.fromHex(add);

      final client = Web3Client(rpc, Client());

      final balance = await client.getBalance(address);

      debugPrint(balance.toString());

      return right(balance);
    } catch (e) {
      return left(WalletException(message: e.toString()));
    }
  }

  Future<Either<AppException, double>> getGasFee(
      String rpc, String token) async {
    print("3");
    try {
      final client = Web3Client(rpc, Client());

      EtherAmount gasPice = await client.getGasPrice();

      // if (token != "ETH") {
      //   final priceResponse = await myHttpClient.get(
      //       url:
      //           "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=ETH",
      //       headers: {});
      // }

      final estimatedGas = await client.estimateGas(
          to: EthereumAddress.fromHex(
              "0xBC06d9A5B95D0902591dd4f0a2B20dBbb998baf4"),
          gasPrice: gasPice,
          sender: EthereumAddress.fromHex(
              "0x5222d5467DC61aFc2EfA95Ef76dCDe411e6e1D35"));
      print(estimatedGas);
      print(gasPice.getInWei / BigInt.from(1000000000));
      print((estimatedGas * gasPice.getInWei) / BigInt.from(pow(10, 18)));

      return right(0);
    } catch (e) {
      print(e);
      return left(WalletException(message: e.toString()));
    }
  }

  Future<Either<AppException, CryptoWallet>> walletConnectInit(
      CryptoWallet wallet) async {
    try {
      await web3walletService.init(wallet);

      return right(wallet);
    } catch (e) {
      return left(WalletException(message: e.toString()));
    }
  }

  Future<Either<AppException, void>> pairWallet(String url) async {
    try {
      web3walletService.count + web3walletService.count + 1;
      await web3walletService.pairWallet(url);

      return right(null);
    } catch (e) {
      return left(WalletException(message: e.toString()));
    }
  }

  Future<Either<AppException, CryptoAccount>> createAccount(
      String seedPhrase, int count,
      {String? name}) async {
    try {
      final keyPair =
          await keyService.keyPairFromMnemonic(seedPhrase, id: count);
      final address =
          await keyService.getAddressFromPrivateKey(keyPair.privateKey);

      return right(CryptoAccount(
          balance: 0,
          id: count,
          keyPair: keyPair,
          address: address,
          name: name ?? "Account $count"));
    } catch (e) {
      return left(WalletException(message: e.toString()));
    }
  }

  Future<Either<AppException, CryptoAccount>> importAccount(
      String privateKey) async {
    try {
      final keyPair = await keyService.keyPairFromPrivateKey(privateKey);
      final address =
          await keyService.getAddressFromPrivateKey(keyPair.privateKey);

      return right(CryptoAccount(
          balance: 0, id: -1, keyPair: keyPair, address: address, name: ""));
    } catch (e) {
      return left(WalletException(message: e.toString()));
    }
  }

  Either<AppException, String> signMessage(String privateKey, String message) {
    try {
      if (privateKey.length != 64) {
        return left(WalletException(message: "Invalid private key length"));
      }
      final ehtPrivateKey = EthPrivateKey.fromHex(privateKey);
      List<int> utf8Bytes = utf8.encode(message);
      Uint8List uint8List = Uint8List.fromList(utf8Bytes);
      Uint8List signature =
          ehtPrivateKey.signPersonalMessageToUint8List(uint8List);

      String signatureHex = signature
          .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
          .join();

      return right("0x$signatureHex");
    } catch (e) {
      return left(WalletException(message: e.toString()));
    }
  }
}

class IsolateService<T> {
  Future<T> execute(T Function() func) async {
    Completer<T> completer = Completer<T>();
    ReceivePort receivePort = ReceivePort();
    ReceivePort errorPort = ReceivePort();

    receivePort.listen((message) {
      completer.complete(message as T);
      receivePort.close();
      errorPort.close();
    });

    errorPort.listen((message) {
      completer.completeError("Wallet Exception");
      receivePort.close();
      errorPort.close();
    });

    await Isolate.spawn(
      _isolateEntry,
      {
        'sendPort': receivePort.sendPort,
        'errorPort': errorPort.sendPort,
        'function': func
      },
    );

    return completer.future;
  }

  static void _isolateEntry(Map<String, dynamic> message) {
    SendPort sendPort = message['sendPort'];
    SendPort errorPort = message['errorPort'];
    Function function = message['function'];

    try {
      // Execute the function in the isolate
      dynamic result = function();

      // Send the result back to the main isolate
      sendPort.send(result);
    } catch (e) {
      // Send error back to main isolate
      errorPort.send(e.toString());
    }
  }
}
