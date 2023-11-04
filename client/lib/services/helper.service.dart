import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HelperService {
final Future<SharedPreferences> sharedPreferences =
      SharedPreferences.getInstance();

  dynamic getProfile() {
  try {
    dynamic decoded = jsonDecode(getToken());
    print('HELPER SERVICE: $decoded');
    return decoded;
  } catch (e) {
    return {};
  }
}


String getToken() {
  sharedPreferences.then((SharedPreferences sp) {
      return sp.getString('token');
    });
  return '';
}

}