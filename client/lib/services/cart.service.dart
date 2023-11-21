import 'dart:convert';

import 'package:book_store_flutter/models/serverResponse.model.dart';
import 'package:http/http.dart' as http;

class CartService{
  static const String baseUrl = 'http://192.168.0.10:8000';
  static const String getCartSizeEndpoint = baseUrl + '/cart/getSize';
  static const String getCartList = baseUrl + '/user/cart';

  


  Future<int> getCartSize(String token) async{
    final response = await http.get(
      Uri.parse(getCartSizeEndpoint),
      headers: {'Authorization': 'Bearer $token'}
      );

      ServerResponse cartSize = ServerResponse.fromJson(json.decode(response.body));
      print('CART SIZE: ${cartSize.data}');
      return cartSize.data;
  }

  Future<ServerResponse> getCartItems(String token) async{
    final response = await http.get(
      Uri.parse(getCartList),
      headers: {'Authorization': 'Bearer $token'}
      );

      ServerResponse cartResponse = ServerResponse.fromJson(json.decode(response.body));
      print('CART BOOK DATA: ${cartResponse}');
      return cartResponse;
  }
}