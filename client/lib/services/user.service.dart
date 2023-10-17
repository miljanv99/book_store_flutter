import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Models
class ServerResponse {
 final bool success;
 final String message;
 final dynamic data;

 ServerResponse({required this.success, required this.message, required this.data});

 factory ServerResponse.fromJson(Map<String, dynamic> json) {
    return ServerResponse(
      success: json['success'],
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

class Receipt {
 final String id;
 final String productName;
 final double price;
 final DateTime purchaseDate;

 Receipt({required this.id, required this.productName, required this.price, required this.purchaseDate});

 factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'],
      productName: json['productName'],
      price: json['price'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
    );
 }
}

class UserService {
 final String baseUrl = 'http://localhost:8000/user';

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

 Future<ServerResponse> login(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ServerResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
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