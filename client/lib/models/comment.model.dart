import 'book.model.dart';
import 'user.model.dart';

class Comment {
 String id;
 User user;
 String content;
 Book book;
 DateTime? creationDate;

 Comment({
    required this.id,
    required this.user,
    required this.content,
    required this.book,
    this.creationDate,
 });

 factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      user: User.fromJson(json['user']),
      content: json['content'],
      book: Book.fromJson(json['book']),
      creationDate: json['creationDate'] != null
          ? DateTime.parse(json['creationDate']!)
          : null,
    );
 }

 Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user.toJson(),
      'content': content,
      //'book': book.toJson(),
      'creationDate': creationDate != null ? creationDate?.toIso8601String() : null,
    };
 }
}