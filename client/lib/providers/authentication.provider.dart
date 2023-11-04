
import 'dart:convert';
import 'package:book_store_flutter/models/user.model.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class AuthorizationProvider extends ChangeNotifier {

  static const String baseUrl = 'http://192.168.221.167:8000/user';
  static const String loginEndpoint = baseUrl + '/login';
  static const profileEndpoint = baseUrl + '/profile/';

  UserService userService = UserService();

  bool _authenticated = false;
  String _token = '';
  String _usermane = '';

  bool get authenticated => _authenticated;
  String get token => _token;
  String get username => _usermane;


  Future<void> authenticate(String token, String username) async {
    _token = token;
    _usermane = username;
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


  Future<User> updateProfile(String username) async {
      ServerResponse response = await userService.getProfile(username, token);
      Map<String, dynamic> userData  = response.data;
      User userProfile = User.fromJson(userData);
      print('UPDATE PROFILE: ${userProfile}');
      return userProfile;
  }
}