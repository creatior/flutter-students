import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalSource {
  final SharedPreferences sharedPreferences;
  LocalSource(this.sharedPreferences);
}
