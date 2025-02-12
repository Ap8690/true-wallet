import "dart:async";
import "dart:convert";
import "package:shared_preferences/shared_preferences.dart";
import "constants/preferences.dart";

class PreferenceService {
  // shared pref instance
  final SharedPreferences _sharedPreference;

  // constructor
  PreferenceService(this._sharedPreference);
  static const String _seedPhraseKey = 'seedPhrase';

  // Save Seed Phrase:---------------------------------------------------------
  Future<bool> saveSeedPhrase(String seedPhrase) async {
    // Check if the seed phrase is already saved
    if (_sharedPreference.containsKey(_seedPhraseKey)) {
      return true; // Seed phrase already exists
    }
    // Save the seed phrase
    await _sharedPreference.setString(_seedPhraseKey, seedPhrase);
    return false; // Seed phrase was not previously set
  }

  // Retrieve Seed Phrase (if needed)
  String? get seedPhrase => _sharedPreference.getString(_seedPhraseKey);

  // General Methods: ----------------------------------------------------------

  Future<void> clearData() async {
    await _sharedPreference.clear();
  }

  Future<void> setConfig(Map<String, String> config) async =>
      await _sharedPreference.setString("appConfig", jsonEncode(config));

  String? getConfig(String p) {
    String? value = _sharedPreference.getString("appConfig");

    if (value != null) {
      return jsonDecode(value)[p];
    }
    return null;
  }

  Future<void> setBiometricStatus(bool bioStatus) async =>
      await _sharedPreference.setBool('bioStatus', bioStatus);

  Future<void> setGeneralNotificationsStatus(bool value) async =>
      await _sharedPreference.setBool("generalNotificationsStatus", value);

  bool get getGeneralNotificationsStatus =>
      _sharedPreference.getBool('generalNotificationsStatus') ?? true;

  Future<void> setSoundStatus(bool value) async =>
      await _sharedPreference.setBool("soundStatus", value);

  bool get getSoundStatus => _sharedPreference.getBool('soundStatus') ?? true;

  Future<void> setVibrateStatus(bool value) async =>
      await _sharedPreference.setBool("vibrateStatus", value);

  bool get getVibrateStatus =>
      _sharedPreference.getBool('vibrateStatus') ?? true;

  bool? get getBiometricStatus =>
      _sharedPreference.getBool('bioStatus') ?? false;

  Future<void> setProfileCreatedStatus(bool isProfileCreated) async =>
      await _sharedPreference.setBool(
          Preferences.isProfileCreated, isProfileCreated);

  bool? get getProfileCreatedStatus =>
      _sharedPreference.getBool(Preferences.isProfileCreated);

  Future<void> saveAccessToken(String accessToken) async =>
      await _sharedPreference.setString(Preferences.accessToken, accessToken);

  String? get accessToken =>
      _sharedPreference.getString(Preferences.accessToken);

  Future<void> setUserId(String userId) async =>
      await _sharedPreference.setString(Preferences.userId, userId);

  String? get userId => _sharedPreference.getString(Preferences.userId);

  Future<void> savePrivateKey(String privateKey) async =>
      await _sharedPreference.setString(Preferences.privateKey, privateKey);

  String? get privateKey => _sharedPreference.getString(Preferences.privateKey);

  Future<void> saveRefreshToken(String refreshToken) async =>
      await _sharedPreference.setString(Preferences.refreshToken, refreshToken);

  String? get refreshToken =>
      _sharedPreference.getString(Preferences.refreshToken);

  Future<void> saveIsMpinSet(bool isMpinSet) async =>
      await _sharedPreference.setBool(Preferences.isMpinSet, isMpinSet);

  bool get isMpinSet =>
      _sharedPreference.getBool(Preferences.isMpinSet) ?? false;

  Future<void> setIsBioEnabled(bool isBioEnabled) =>
      _sharedPreference.setBool(Preferences.isBioEnabled, isBioEnabled);

  bool? get isBioEnabled => _sharedPreference.getBool(Preferences.isBioEnabled);

  Future<void> saveMpin(String mpin) =>
      _sharedPreference.setString(Preferences.mpin, mpin);

  String? get mpin => _sharedPreference.getString(Preferences.mpin);

  Future<bool> removeAccessToken() async =>
      _sharedPreference.remove(Preferences.accessToken);

  Future<bool> remove(String key) async => _sharedPreference.remove(key);

  // Login:---------------------------------------------------------------------
  bool get isLoggedIn =>
      _sharedPreference.getBool(Preferences.isLoggedIn) ?? false;

  Future<bool> saveIsLoggedIn(bool value) async =>
      _sharedPreference.setBool(Preferences.isLoggedIn, value);

  bool get isGusetUser =>
      _sharedPreference.getBool(Preferences.isGuestUser) ?? false;

  Future<bool> saveIsGuestUser(bool value) async =>
      _sharedPreference.setBool(Preferences.isGuestUser, value);

  Future<bool> saveIsFirstTimeUser(bool value) async =>
      _sharedPreference.setBool(Preferences.isFirstTimeUser, value);

  bool get isFirstTimeUser =>
      _sharedPreference.getBool(Preferences.isFirstTimeUser) ?? false;

  // Theme:------------------------------------------------------
  bool get isDarkMode =>
      _sharedPreference.getBool(Preferences.isDarkMode) ?? false;

  Future<void> changeBrightnessToDark(bool value) =>
      _sharedPreference.setBool(Preferences.isDarkMode, value);

  // Language:---------------------------------------------------
  String? get currentLanguage =>
      _sharedPreference.getString(Preferences.currentLanguage);

  Future<void> changeLanguage(String language) =>
      _sharedPreference.setString(Preferences.currentLanguage, language);

  static const String _profileImageUrlKey = 'profile_image_url';
// Profile Image:-------------------------------------------------------------
  Future<void> setProfileImageUrl(String url) async =>
      await _sharedPreference.setString(_profileImageUrlKey, url);

  String? get profileImageUrl =>
      _sharedPreference.getString(_profileImageUrlKey);
  // Username:-------------------------------------------------------------
  static const String _usernameKey = 'username';

  Future<void> setUsername(String username) async =>
      await _sharedPreference.setString(_usernameKey, username);

  String? get username => _sharedPreference.getString(_usernameKey);

  // Referral Code:-------------------------------------------------------------
  static const String _referralCodeKey = 'referral_code';

  Future<void> setReferralCode(String code) async =>
      await _sharedPreference.setString(_referralCodeKey, code);

  String? get referralCode => _sharedPreference.getString(_referralCodeKey);
}
