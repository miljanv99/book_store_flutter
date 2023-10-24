import 'dart:convert';
import 'package:book_store_flutter/models/book.model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class BookService {
 static const String domain = 'http://192.168.52.209:8000';
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

  Future<List<Book>> fetchDataFromServer(String query)async{
  //final Dio dio =  Dio();
  
    //var response = await dio.get('$searchBookEndpoint$query');

   // if (response.statusCode == 200) {
    //print(response.statusCode);
    //print(response.data['data'].length);
   // List<dynamic> responseData = response.data['data'] ;

    // List<Book> updatedList = responseData.map((e) => Book.fromJson(e)).toList();      


    // return updatedList;
   // }

   // throw Exception('Failed to load data');

    var url = Uri.parse('$searchBookEndpoint$query');

    var apiResponse = await http.get(url);

    if (apiResponse.statusCode == 200) {
      List<dynamic> responseData = json.decode(apiResponse.body)['data'];
      List<Book> updatedList = responseData.map((e) => Book.fromJson(e)).toList();
      return updatedList;
    } else {
      throw Exception('Failed to load data');
    }
  }
 }