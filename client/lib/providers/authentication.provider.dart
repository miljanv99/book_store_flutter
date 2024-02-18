import 'package:book_store_flutter/models/user.model.dart';
import 'package:book_store_flutter/providers/screenProvider.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


import '../models/book.model.dart';
import '../models/receipt.model.dart';
import '../models/serverResponse.model.dart';

class AuthorizationProvider extends ChangeNotifier {
  static const String baseUrl = 'http://192.168.0.10:8000/user';
  static const String loginEndpoint = '$baseUrl/login';
  static const profileEndpoint = '$baseUrl/profile/';

  UserService userService = UserService();
  ScreenProvider screenProvider = ScreenProvider();
  CartService cartService = CartService();

  bool _authenticated = false;
  String _token = '';
  String _userId = '';
  String _usermane = '';
  int _cartSize = 0;

  bool get authenticated => _authenticated;
  String get token => _token;
  String get username => _usermane;
  String get userId => _userId;
  int get cartSize => _cartSize;

   set cartSize(int value) {
    _cartSize = value;
    notifyListeners();
  }

  Future<void> authenticate(String token, String username) async {
    _token = token;
    _usermane = username;
    _authenticated = true;
    _cartSize = await cartService.getCartSize(token);
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
    Map<String, dynamic> userData = response.data;
    _userId = userData['id'];
    User userProfile = User.fromJson(userData);
    print('UPDATE PROFILE: ${userProfile}');
    return userProfile;
  }


  Future<List<Receipt>> updatePurchaseHistory(String token) async {
  ServerResponse response = await userService.getPurchaseHistory(token);
  List<dynamic> receiptDataList = response.data;
  List<Receipt> receiptList = [];

  for (var receiptData in receiptDataList) {
    User user = User.fromJson({'id': receiptData['user']});
    String id = receiptData['_id'];
    List<Book> productsInfo = List<Book>.from(receiptData['productsInfo'].map((item) => Book.fromJson(item)));
    double totalPrice = receiptData['totalPrice'].toDouble();
    DateTime creationDate = DateTime.parse(receiptData['creationDate']);

    Receipt receipt = Receipt(id: id, user: user, productsInfo: productsInfo, totalPrice: totalPrice, creationDate: creationDate);
    receiptList.add(receipt);
  }

  print('RECEIPT DATA: ${receiptList}');
  return receiptList;
}
}
