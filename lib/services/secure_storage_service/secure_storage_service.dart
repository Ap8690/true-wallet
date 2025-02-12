import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _pin;

  String generateEncryptionKey(String string) {
    return base64.encode(utf8.encode("0${string * 5}0"));
  }

  Future<void> savePassword(String pin) async {
    final key0 = encrypt.Key.fromBase64(generateEncryptionKey(pin));
    final encrypter = encrypt.Encrypter(encrypt.AES(key0));
    final encryptedData = encrypter.encrypt(pin, iv: _generateIV(pin));
    await _storage.write(key: "pin", value: encryptedData.base64);
    _pin = pin;
  }

  Future<bool> verifyPassword(String pin) async {
    final key0 = encrypt.Key.fromBase64(generateEncryptionKey(pin));
    final encryptedData = await _storage.read(key: "pin");
    try {
      if (encryptedData != null) {
        final encrypter = encrypt.Encrypter(encrypt.AES(key0));
        final decryptedData =
            encrypter.decrypt64(encryptedData, iv: _generateIV(pin));
        if (decryptedData == pin) {
          _pin = pin;
          return true;
        }
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> saveWithPin(String key, String data) async {
    if (_pin == null) {
      throw "Pin not found";
    }
    final key0 = encrypt.Key.fromBase64(generateEncryptionKey(_pin!));
    final encrypter = encrypt.Encrypter(encrypt.AES(key0));
    final encryptedData = encrypter.encrypt(data, iv: _generateIV(_pin!));
    await _storage.write(key: key, value: encryptedData.base64);
  }

  Future<String?> fetchWithPin(String key) async {
    if (_pin == null) {
      throw "Pin not found";
    }
    final key0 = encrypt.Key.fromBase64(generateEncryptionKey(_pin!));
    final encryptedData = await _storage.read(key: key);
    try {
      if (encryptedData != null) {
        final encrypter = encrypt.Encrypter(encrypt.AES(key0));
        final decryptedData =
            encrypter.decrypt64(encryptedData, iv: _generateIV(_pin!));

        return decryptedData;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> save(String key, String data) async {
    await _storage.write(key: key, value: data);
  }

  Future<String?> fetch(String key) async {
    final data = await _storage.read(key: key);
    return data;
  }

  encrypt.IV _generateIV(String pin) {
    final keyBytes = utf8.encode(pin);
    final iv = encrypt.IV.fromUtf8(base64Url.encode(keyBytes));
    return iv;
  }
}
// T0RnNE9EazU=