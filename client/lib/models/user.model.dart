class User {
 String? id;
 String? username;
 String? email;
 String? avatar;
 bool? isAdmin;
 int? commentsCount;
 //cart Cart;
 List<dynamic>? favoriteBooks;
 //receipts Receipt[]


 User({required this.id, required this.username, required this.email ,required this.avatar, required this.isAdmin, required this.commentsCount, required this.favoriteBooks});

 factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      avatar: json['avatar'],
      isAdmin: json['isAdmin'],
      commentsCount: json['commentsCount'],
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
      'commentsCount': commentsCount,
      'favoriteBooks': favoriteBooks
    };
 }
}