import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  String generateEncryptionKey(String string) {
    return base64.encode(utf8.encode("0${string * 5}0"));
  }

  Future<void> savePassword(String password) async {
    await _storage.write(key: 'password', value: password);
  }

  Future<bool> verifyPassword(String password) async {
    final storedPassword = await _storage.read(key: 'password');
    return storedPassword == password;
  }

  Future<void> saveWithPin(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> fetchWithPin(String key) async {
    return await _storage.read(key: key);
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