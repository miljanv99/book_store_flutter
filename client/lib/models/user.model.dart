

import 'book.model.dart';

class User {
 String? id;
 String? username;
 String? avatar;
 bool? isAdmin;
 int? commentCount;
 //cart Cart;
 List<Book> favoriteBooks;
 //receipts Receipt[]


 User({required this.id, required this.username, required this.avatar, required this.isAdmin, required this.commentCount, required this.favoriteBooks});

 factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      avatar: json['avatar'],
      isAdmin: json['isAdmin'],
      commentCount: json['commentCount'],
      favoriteBooks: json['favoriteBooks']
    );
 }

 Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'avatar': avatar,
      'isAdmin': isAdmin,
      'commentCount': commentCount,
      'favoriteBooks': favoriteBooks
    };
 }
}