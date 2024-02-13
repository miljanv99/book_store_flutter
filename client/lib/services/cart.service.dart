import 'dart:convert';
import 'package:book_store_flutter/models/serverResponse.model.dart';
import 'package:http/http.dart' as http;


class CartService {
  static const String baseUrl = 'http://192.168.0.10:8000';
  static const String getCartSizeEndpoint = '$baseUrl/cart/getSize';
  static const String getCartList = '$baseUrl/user/cart';
  static const String addToCart = '$baseUrl/user/cart/add/';
  static const String cartCheckout = '$baseUrl/user/cart/checkout';
  static const String removeBook = '$baseUrl/user/cart/delete/';
  static const String removeAll = '$baseUrl/user/cart/deleteAll';

  Future<int> getCartSize(String token) async {
    final response = await http.get(Uri.parse(getCartSizeEndpoint),
        headers: {'Authorization': 'Bearer $token'});

    ServerResponse cartSize =
        ServerResponse.fromJson(json.decode(response.body));
    print('CART SIZE: ${cartSize.data}');

    return cartSize.data;
  }

  Future<ServerResponse> getCart(String token) async {
    final response = await http.get(Uri.parse(getCartList),
        headers: {'Authorization': 'Bearer $token'});

    ServerResponse cartResponse =
        ServerResponse.fromJson(json.decode(response.body));
    print('CART BOOK DATA: ${cartResponse.data}');
    return cartResponse;
  }

  Future<ServerResponse> addBookToCart(String token, String bookId) async {
    final response = await http.post(
      Uri.parse('$addToCart$bookId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    var responseData = ServerResponse.fromJson(json.decode(response.body));
    //print('BODY ${responseData}');
    print('Add to cart response ${responseData.message}');
    return responseData;
  }

  Future<String> checkout(String token, Map<String, dynamic> payload) async {
      print('PAYLOAD: ${payload}');
      print('TOKEN ${token}');
    try {
      final response = await http.post(
        Uri.parse(cartCheckout),
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );

        
      if (response.statusCode == 200) {
        ServerResponse checkoutResponse =
            ServerResponse.fromJson(json.decode(response.body));
        return checkoutResponse.message;
      } else {
        // Handle non-200 status codes
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
        return 'Error during checkout';
      }
    } catch (e) {
      // Handle network or other exceptions
      print('Exception: $e');
      return 'Error during checkout';
    }
  }

  Future<ServerResponse> removeBookFromCart(String token, String bookId) async{
    final response = await http.delete(
      Uri.parse('$removeBook$bookId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    var responseData = ServerResponse.fromJson(json.decode(response.body));
    //print('BODY ${responseData}');
    return responseData;
  }

  Future<ServerResponse> removeAllFromCart(String token) async{
    final response = await http.delete(
      Uri.parse(removeAll),
      headers: {'Authorization': 'Bearer $token'},
    );

    var responseData = ServerResponse.fromJson(json.decode(response.body));
    //print('BODY ${responseData}');
    return responseData;
  }
}
