import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:web3dart/web3dart.dart';

class CryptoWallet {
  final String seedPhrase;
  final List<CryptoAccount> accounts;

  CryptoWallet({required this.seedPhrase, required this.accounts});

  Map<String, dynamic> toJson() {
    return {
      'seedPhrase': seedPhrase,
      'accounts': accounts.map((account) => account.toJson()).toList(),
    };
  }

  factory CryptoWallet.fromJson(Map<String, dynamic> json) {
    return CryptoWallet(
      seedPhrase: json['seedPhrase'],
      accounts: List<CryptoAccount>.from(json['accounts']
          .map((accountJson) => CryptoAccount.fromJson(accountJson))),
    );
  }
}

enum AccountSource { imported, seed }

class CryptoAccount {
  final AccountSource source;
  String name;
  double balance;
  final int id;
  final CryptoKeyPair keyPair;
  final String address;

  CryptoAccount({
    required this.balance,
    required this.id,
    required this.name,
    this.source = AccountSource.seed,
    required this.keyPair,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'balance': balance.toDouble(),
      'source': source.toString().split('.').last,
      'keyPair': keyPair.toJson(),
      'address': address,
      "name": name,
      "id": id,
    };
  }

  Credentials toCredential() {
    return EthPrivateKey.fromHex(keyPair.privateKey);
  }

  factory CryptoAccount.fromJson(Map<String, dynamic> json) {
    return CryptoAccount(
      balance: json['balance'] != null
          ? double.parse(json['balance'].toString())
          : double.parse('0'),
      id: json['id'],
      name: json['name'],
      source: json['source'] == 'imported'
          ? AccountSource.imported
          : AccountSource.seed,
      keyPair: CryptoKeyPair.fromJson(json['keyPair']),
      address: json['address'],
    );
  }
}

class CryptoKeyPair {
  final String privateKey;
  final String publicKey;

  const CryptoKeyPair(this.privateKey, this.publicKey);

  Map<String, dynamic> toJson() {
    return {
      'privateKey': privateKey,
      'publicKey': publicKey,
    };
  }

  factory CryptoKeyPair.fromJson(Map<String, dynamic> json) {
    return CryptoKeyPair(
      json['privateKey'],
      json['publicKey'],
    );
  }

  Uint8List getPrivateKeyBytes() {
    return Uint8List.fromList(hex.decode(privateKey));
  }

  Uint8List getPublicKeyBytes() {
    return Uint8List.fromList(hex.decode(publicKey));
  }
}
