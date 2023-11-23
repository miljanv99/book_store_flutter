import 'book.model.dart';

class Cart {
  String? user;
  List<Book>? books;
  num? totalPrice;

  Cart({required this.user, required this.books, required this.totalPrice});


  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      user: json['user'],
      books: (json['books'] as List<dynamic>).map((bookJson) {
      return Book.fromJson(bookJson);
    }).toList(),
      totalPrice: json['totalPrice'],
    );
 }

 Map<String, dynamic> toJson() {
    return {
      'user': user,
      'books': books,
      'totalPrice': totalPrice,
    };
 }

}