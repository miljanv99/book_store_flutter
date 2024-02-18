import 'cart.model.dart';

class User {
 String? id;
 String? username;
 String? email;
 String? avatar;
 bool? isAdmin;
 int? commentsCount;
 Cart? cart;
 List<dynamic>? favoriteBooks;

 User({required this.id, required this.username, required this.email ,required this.avatar, required this.isAdmin, required this.commentsCount, required this.cart ,required this.favoriteBooks});

 factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      avatar: json['avatar'],
      isAdmin: json['isAdmin'],
      commentsCount: json['commentsCount'],
      cart: json['cart'],
      favoriteBooks: json['favoriteBooks'] is List ? json['favoriteBooks'] : [],
    );
 }

 Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'avatar': avatar,
      'isAdmin': isAdmin,
      'commentsCount': commentsCount,
      'cart': cart,
      'favoriteBooks': favoriteBooks
    };
 }
}