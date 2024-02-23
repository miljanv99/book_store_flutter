import 'package:book_store_flutter/models/user.model.dart';

class Comment {
  String? id;
  String? content;
  DateTime? creationDate;
  int? v;
  String? book;
  User? user;

  Comment({
    this.id,
    this.content,
    this.creationDate,
    this.v,
    this.book,
    this.user,
  });

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    content = json['content'];
    if (json['creationDate'] != null) {
      creationDate = DateTime.parse(json['creationDate']);
    }
    v = json['__v'];
    book = json['book'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'creationDate': creationDate,
      '__v': v,
      'book': book,
      'user': user?.toJson(),
    };
  }
}
