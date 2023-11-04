import 'book.model.dart';

class User {
 String? id;
 String? username;
 String? email;
 String? avatar;
 bool? isAdmin;
 int? commentCount;
 //cart Cart;
 List<dynamic> favoriteBooks;
 //receipts Receipt[]


 User({required this.id, required this.username, required this.email ,required this.avatar, required this.isAdmin, required this.commentCount, required this.favoriteBooks});

 factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
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
      'email': email,
      'avatar': avatar,
      'isAdmin': isAdmin,
      'commentCount': commentCount,
      'favoriteBooks': favoriteBooks
    };
 }
}