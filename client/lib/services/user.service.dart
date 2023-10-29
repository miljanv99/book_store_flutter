import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Models
class ServerResponse {
  final String message;
  final dynamic data;

  ServerResponse({required this.message, required this.data});

  factory ServerResponse.fromJson(Map<String, dynamic> json) {
    return ServerResponse(
      message: json['message'],
      data: json['data'],
    );
  }
}

class User {
  final String username;
  final String email;
  final String avatar;

  User({required this.username, required this.email, required this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }
}

class UserService {
  static const String baseUrl = 'http://192.168.0.14:8000/user';
  static const String loginEndpoint = baseUrl + '/login';

  Future<ServerResponse> register(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ServerResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<dynamic> login(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse(loginEndpoint),
      body: jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );

    var responseData = ServerResponse.fromJson(json.decode(response.body));
    print('BODY ${responseData}');
    print('TOKEN ${responseData.data}');
    return responseData;
  }

  Future<ServerResponse> getProfile(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile/$username'),
    );

    if (response.statusCode == 200) {
      return ServerResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get profile');
    }
  }

  Future<ServerResponse> getPurchaseHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/purchaseHistory'),
    );

    if (response.statusCode == 200) {
      return ServerResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get purchase history');
    }
  }

  Future<ServerResponse> changeAvatar(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/changeAvatar'),
      body: jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ServerResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to change avatar');
    }
  }

  Future<ServerResponse> blockComments(String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/blockComments/$id'),
      body: jsonEncode({}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ServerResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to block comments');
    }
  }

  Future<ServerResponse> unblockComments(String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/unlockComments/$id'),
      body: jsonEncode({}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ServerResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to unblock comments');
    }
  }
}
