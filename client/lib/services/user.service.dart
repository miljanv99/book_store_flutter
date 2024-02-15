import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/serverResponse.model.dart';


class UserService {
  static const String baseUrl = 'http://192.168.0.10:8000/user';
  static const String loginEndpoint = '$baseUrl/login';
  static const String profileEndpoint = '$baseUrl/profile/';
  static const String getPurchaseHistoryEndpoint = '$baseUrl/purchaseHistory';
  static const String registerEndpoint = '$baseUrl/register';
  static const String changeAvatarEndpoint = '$baseUrl/changeAvatar';

  Future<ServerResponse> registerUser(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse(registerEndpoint),
      body: jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );

    var responseData = ServerResponse.fromJson(json.decode(response.body));
    print('registerData ${responseData.message}');
    return responseData;
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

    ServerResponse userProfile = ServerResponse.fromJson(json.decode(response.body));
    print('PROFILE BODY: ${userProfile.data}');
    return userProfile;
    
  }

 

  Future<ServerResponse> getPurchaseHistory(String token) async {
    final response = await http.get(
      Uri.parse(getPurchaseHistoryEndpoint),
      headers: {'Authorization': 'Bearer $token'}
    );

    if (response.statusCode == 200) {
      return ServerResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get purchase history');
    }
  }

  Future<ServerResponse> changeAvatar(String token , Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('${changeAvatarEndpoint}'),
      body: jsonEncode(payload),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        }
    );

    if (response.statusCode == 200) {
      return ServerResponse.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
      return ServerResponse.fromJson(jsonDecode(response.body));
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
