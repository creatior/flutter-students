import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalSource {
  final SharedPreferences sharedPreferences;
  LocalSource(this.sharedPreferences);

  Future<void> setToken(String key, String token) async {
    await sharedPreferences.setString(key, token);
  }

  Future<String?> getToken(String key) async {
    return sharedPreferences.getString(key);
  }
}
