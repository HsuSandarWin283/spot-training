import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _keyRememberEmail = 'remember_email';
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyRememberMe = 'remember_me';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  Future<void> saveRememberEmail(String email) async {
    await _prefs.setString(_keyRememberEmail, email);
  }

  String? getRememberEmail() {
    return _prefs.getString(_keyRememberEmail);
  }

  Future<void> clearRememberEmail() async {
    await _prefs.remove(_keyRememberEmail);
  }

  Future<void> setRememberMe(bool value) async {
    await _prefs.setBool(_keyRememberMe, value);
  }

  bool get isRememberMe {
    return _prefs.getBool(_keyRememberMe) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_keyIsLoggedIn, value);
  }

  bool get isLoggedIn {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
