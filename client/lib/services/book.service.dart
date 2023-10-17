import 'dart:convert';
import 'package:book_store_flutter/models/book.model.dart';
import 'package:http/http.dart' as http;

class BookService {
 static const String domain = 'http://localhost:8000';
 static const String getSingleBookEndpoint = domain + '/book/details/';
 static const String createBookEndpoint = domain + '/book/add';
 static const String editBookEndpoint = domain + '/book/edit/';
 static const String deleteBookEndpoint = domain + '/book/delete/';
 static const String rateBookEndpoint = domain + '/book/rate/';
 static const String addToFavoritesEndpoint = domain + '/book/addToFavorites/';
 static const String searchBookEndpoint = domain + '/book/search';

 Future<dynamic> getSingleBook(String id) async {
    final response = await http.get((getSingleBookEndpoint + id) as Uri);
    return jsonDecode(response.body);
 }

 Future<dynamic> createBook(Map<String, dynamic> payload) async {
    final response = await http.post(createBookEndpoint as Uri, body: payload);
    return jsonDecode(response.body);
 }

 Future<dynamic> editBook(String id, Map<String, dynamic> payload) async {
    final response = await http.put((editBookEndpoint + id) as Uri, body: payload);
    return jsonDecode(response.body);
 }

 Future<dynamic> deleteBook(String id) async {
    final response = await http.delete((deleteBookEndpoint + id) as Uri);
    return jsonDecode(response.body);
 }

 Future<dynamic> rateBook(String id, Map<String, dynamic> payload) async {
    final response = await http.post((rateBookEndpoint + id) as Uri, body: payload);
    return jsonDecode(response.body);
 }

 Future<dynamic> addToFavourites(String id) async {
    final response = await http.post((addToFavoritesEndpoint + id) as Uri, body: {});
    return jsonDecode(response.body);
 }

 Future<void> search(String query) async {
    final response = await http.get(Uri.parse(searchBookEndpoint + query));
    
    
 }
}