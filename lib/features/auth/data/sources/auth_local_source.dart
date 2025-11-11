import 'package:students_list/res/sources/local_source.dart';

class AuthLocalSource extends LocalSource {
  AuthLocalSource(super.sharedPreferences);

  Future<void> clearTokens() async {
    await sharedPreferences.remove('access_token');
    await sharedPreferences.remove('refresh_token');
  }
}
