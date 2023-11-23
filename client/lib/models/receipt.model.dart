
import 'package:book_store_flutter/models/user.model.dart';

import 'book.model.dart';

class Receipt {
  String id;
  User user;
  List<Book> productsInfo;
  String totalPrice;
  DateTime creationDate;

  Receipt({required this.id, required this.user, required this.productsInfo, required this.totalPrice, required this.creationDate});


   factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['_id'],
      user: json['user'],
      productsInfo: json['productsInfo'],
      totalPrice: json['totalPrice'],
      creationDate: json['creationDate'],
    );
 }

 Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'productsInfo': productsInfo,
      'totalPrice': totalPrice,
      'creationDate': creationDate
    };
 }
}