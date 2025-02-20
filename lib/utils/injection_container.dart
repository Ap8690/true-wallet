import 'package:flutter_application_1/core/network/http_client.dart';
import 'package:flutter_application_1/services/chain/chain_service.dart';
import 'package:flutter_application_1/services/secure_storage_service/secure_storage_service.dart';
import 'package:flutter_application_1/services/send/send_service.dart';
import 'package:flutter_application_1/services/sharedpref/preference_service.dart';
import 'package:flutter_application_1/services/wallet/key_service/key_service.dart';
import 'package:flutter_application_1/services/wallet/wallet_service.dart';
import 'package:flutter_application_1/services/wallet/web3wallet_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final sl = GetIt.instance;

Future<void> init() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final secureStorage = const FlutterSecureStorage();
  
  sl.registerLazySingleton<PreferenceService>(
      () => PreferenceService(preferences));
  sl.registerLazySingleton<MyHttpClient>(() => HttpClientImpl());

  sl.registerLazySingleton<WalletService>(() => WalletService());
  sl.registerLazySingleton<KeyService>(() => KeyService());
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(secureStorage)
  );
  sl.registerLazySingleton<WalletConnectService>(() => WalletConnectService());
  sl.registerLazySingleton<NetworksService>(() => NetworksService());
  sl.registerLazySingleton<SendService>(() => SendService());
}
