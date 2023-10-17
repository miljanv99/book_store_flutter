import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/book.model.dart';
import '../services/book.service.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {



    List<Book> newestBooks = [];
    List<dynamic> bestRatedBooks = [];
    List<dynamic> mostPurchasedBooks = [];

    BookService bookService = BookService();
    List<Book> books = [];

  String newestBooksQuery = '?sort={"creationDate":-1}&limit=5';
 String bestRatedBooksQuery = '?sort={"currentRating":-1}&limit=5';
 String mostPurchasedBooksQuery = '?sort={"purchasesCount":-1}&limit=5';

  static const String domain = 'http://192.168.52.209:8000';
  static const String searchBookEndpoint = domain + '/book/search';
 

 void fetchDataFromServer()async{
  final Dio dio =  Dio();

  try {
    var response = await dio.get("$searchBookEndpoint");
    print(response.statusCode);
    print(response.data['data'].length);
    List<dynamic> responseData = response.data['data'] ;

    //final List<Map<String, dynamic>> responseData = json.decode(response.data);

    setState(() {
      books = responseData.map((e) => Book.fromJson(e)).toList();      
    });
  } on DioError catch (e) {
    print(e);
  }
 }

 @override
 void initState(){
  super.initState();
  fetchDataFromServer();
 }



 

 //Future<List<Book>> getPosts() async {
 // var url = Uri.parse("http://localhost:8000/book/search");
 // final response = await http.get(url, headers: {"Content-Type": //"application/json"});
 // final List body = json.decode(response.body);
 // return body.map((e) => Book.fromJson(e)).toList();
//}
 

  //Future<List<Book>> search(String query) async {
   
    //final response = await http.get(Uri.parse(searchBookEndpoint + query));
      //final List<dynamic> json = jsonDecode(response.body);
      //newestBooks = json.map((item) => Book.fromJson(item)).toList();
      //print(newestBooks);
      //return json.map((item) => Book.fromJson(item)).toList();  
//}

  @override
  Widget build(BuildContext context) {
 //Future<List<Book>> postsFuture = getPosts();
    return Container(
      child: ListView(
        children: <Widget>[
          ...books.map(
            (book) => GestureDetector(
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.yellow.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 3), // changes position of shadow
                    )
                  ]
                ),
                child: ListTile(
                tileColor: Colors.greenAccent,
                title: Text("${book.title}"),
                leading: Image.network("${book.cover}") 
                ),
              ),
              onTap: (){
                print('${book.title} - ${book.id}');
              },
            )
          )
        ],
      )
    );
  }
}
