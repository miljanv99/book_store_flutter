import 'dart:convert';
import 'package:book_store_flutter/models/serverResponse.model.dart';
import 'package:http/http.dart' as http;

class CommentService {
  static const String domain = 'http://192.168.0.10:8000';
  static const String getCommentsForSingleBookEndpoint = '$domain/comment/';
  static const String addCommentForSingleBookEndpoint = '$domain/comment/add/';

  Future<ServerResponse> getComments(String bookId, num skipCount) async {
    final response = await http.get(
      Uri.parse('$getCommentsForSingleBookEndpoint$bookId/$skipCount'),
    );

    var responseData = ServerResponse.fromJson(json.decode(response.body));
    print('Book`s comments: ${responseData.data}');
    return responseData;
  }

  Future<ServerResponse> addComment(String token, String bookId, Map<String, dynamic> payload) async{
    final response = await http.post(
      Uri.parse('$addCommentForSingleBookEndpoint$bookId'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(payload)
    );
    var responseData = ServerResponse.fromJson(json.decode(response.body));
    print('Added comment: ${responseData.data}');
    return responseData;
  }
}