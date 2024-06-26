import 'dart:convert';
import 'package:book_store_flutter/models/book.model.dart';
import 'package:book_store_flutter/models/serverResponse.model.dart';
import 'package:http/http.dart' as http;

//for emulator: 10.0.2.2

class BookService {
  static const String domain = 'http://192.168.0.10:8000';
  static const String getSingleBookEndpoint = '$domain/book/details/';
  static const String rateBookEndpoint = '$domain/book/rate/';
  static const String addToFavoritesEndpoint = '$domain/book/addToFavorites/';
  static const String searchBookEndpoint = '$domain/book/search';

  Future<void> addOrRemoveFavouriteBook(String token, String bookId) async {
    await http.post(
      Uri.parse('$addToFavoritesEndpoint$bookId'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<List<Book>> fetchBooksFromServer({String? query}) async {
    Uri url;
    if (query != null) {
      url = Uri.parse('$searchBookEndpoint$query');
    } else {
      url = Uri.parse(searchBookEndpoint);
    }

    var apiResponse = await http.get(url);

    if (apiResponse.statusCode == 200) {
      List<dynamic> responseData = json.decode(apiResponse.body)['data'];
      List<Book> updatedList =
          responseData.map((e) => Book.fromJson(e)).toList();
      return updatedList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Book> getSingleBook(String id) async {
    Uri url = Uri.parse('$getSingleBookEndpoint$id');

    var apiResponse = await http.get(url);

    if (apiResponse.statusCode == 200) {
      var responseData = Book.fromJson(json.decode(apiResponse.body)['data']);
      print(responseData);
      return responseData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<ServerResponse> rateTheBook(String token, String bookId, payload) async {
    final response = await http.post(
      Uri.parse('$rateBookEndpoint$bookId'),
      headers: {'Content-Type': 'application/json','Authorization': 'Bearer $token'},
      body: jsonEncode(payload)
    );

    var responseData = ServerResponse.fromJson(json.decode(response.body));
    print('Rate Book ${responseData.message}');
    return responseData;
  }
}
