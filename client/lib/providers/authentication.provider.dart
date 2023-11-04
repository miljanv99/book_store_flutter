
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class AuthorizationProvider extends ChangeNotifier {

  static const String baseUrl = 'http://192.168.221.167:8000/user';
  static const String loginEndpoint = baseUrl + '/login';
  static const profileEndpoint = baseUrl + '/profile/';

  bool _authenticated = false;
  String _token = '';

  bool get authenticated => _authenticated;
  String get token => _token;


  Future<void> authenticate(String token) async {
    _token = token;
    _authenticated = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    print('IN SIGN OUT $_token');
    _token = '';
    _authenticated = false;
    print('IN SIGN OUT $_authenticated');
    notifyListeners();
  }

  Future<void> updateProfile() async {
    if (_authenticated) {
      String profileUrl = 'https://example.com/profile'; // Replace with your profile API URL

      Map<String, String> headers = {
        'Authorization': 'Bearer $_token',
      };

      final response = await http.get(Uri.parse(profileUrl), headers: headers);

      if (response.statusCode == 200) {
        // Parse the response and update the user's profile in your app's state
        // ...
      } else {
        // Handle errors
        // ...
      }
    }
  }
}