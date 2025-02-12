import 'dart:isolate';

import 'package:flutter_application_1/services/wallet/models/wallet_model.dart';
import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/services/wallet/bip39/bip39_base.dart' as bip39;
import 'package:flutter_application_1/services/wallet/bip32/bip32_base.dart' as bip32;
import 'package:web3dart/web3dart.dart';

class KeyService {
  final List<CryptoAccount> keys = [];

  List<CryptoAccount> getKeysForChain(String chain) {
    return keys;
  }

  Future<String> generateMnemonic() async => await Isolate.run(() {
        return bip39.generateMnemonic();
      });

  Future<CryptoKeyPair> keyPairFromMnemonic(String mnemonic,
      {int id = 0}) async {
    return await Isolate.run(() {
      final isValidMnemonic = bip39.validateMnemonic(mnemonic);
      if (!isValidMnemonic) {
        throw 'Invalid mnemonic';
      }

      final seed = bip39.mnemonicToSeed(mnemonic);
      final root = bip32.BIP32.fromSeed(seed);
      final firstChild = root.derivePath("m/44'/60'/0'/0/$id");
      final private = hex.encode(firstChild.privateKey as List<int>);
      final public = hex.encode(firstChild.publicKey);
      return CryptoKeyPair(private, public);
    });
  }

  Future<CryptoKeyPair> keyPairFromPrivateKey(String privateKeyHex) async {
    return await Isolate.run(() {
      final EthPrivateKey ethPrivateKey = EthPrivateKey.fromHex(privateKeyHex);
      final privateKey = hex.encode(ethPrivateKey.privateKey);
      final publicKey = hex.encode(ethPrivateKey.publicKey.getEncoded());
      return CryptoKeyPair(privateKey, publicKey);
    });
  }

  Future<String> getAddressFromPrivateKey(String privateKey) async {
    return await Isolate.run(() {
      final private = EthPrivateKey.fromHex(privateKey);
      return private.address.hexEip55;
    });
  }

  Future<CryptoWallet> createWallet() async {
    final mnemonic = await generateMnemonic();
    return CryptoWallet(
        accounts: [await restoreWallet(mnemonic: mnemonic)],
        seedPhrase: mnemonic);
  }

  Future<CryptoWallet> importWallet(String mnemonic, {int count = 1}) async {
    List<CryptoAccount> accountList = [];
    for (var i = 0; i < count; i++) {
      accountList.add(await restoreWallet(mnemonic: mnemonic, id: i));
    }
    return CryptoWallet(accounts: accountList, seedPhrase: mnemonic);
  }



  Future<CryptoAccount> restoreWallet(
      {required String mnemonic, int id = 0}) async {
    final keyPair = await keyPairFromMnemonic(mnemonic, id: id);

    final address = await getAddressFromPrivateKey(keyPair.privateKey);
    final evmChainKey = CryptoAccount(
        balance: 0,
        id: id,
        keyPair: CryptoKeyPair(keyPair.privateKey, keyPair.publicKey),
        address: address,
        name: 'Account $id');
    debugPrint('[WALLET] ${evmChainKey.toString()}');
    return evmChainKey;
  }

  Future<void> deleteWallet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    keys.clear();
    return;
  }
}
