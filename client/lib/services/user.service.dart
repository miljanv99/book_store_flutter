import 'dart:convert';
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

class UserService {
  static const String baseUrl = 'http://192.168.221.167:8000/user';
  static const String loginEndpoint = baseUrl + '/login';
  static const profileEndpoint = baseUrl + '/profile/';

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

  Future<dynamic> userLogin(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse(loginEndpoint),
      body: jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );

    var responseData = ServerResponse.fromJson(json.decode(response.body));
    //print('BODY ${responseData}');
    print('responseData ${responseData}');
    return responseData;
  }

     Future<ServerResponse> getProfile(String username, String token) async {
  
    final response = await http.get(
      Uri.parse('$profileEndpoint$username'),
      headers: {'Authorization': 'Bearer $token'}
    );

    ServerResponse responseData = ServerResponse.fromJson(json.decode(response.body));
    print('PROFILE BODY: ${responseData.data}');
    ServerResponse userProfile = responseData;
    return userProfile;
    
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
