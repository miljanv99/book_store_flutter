import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/widgets/bookHorizontalList.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.model.dart';
import '../services/book.service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Book>> newestBooks;
  late Future<List<Book>> bestRatedBooks;
  late Future<List<Book>> mostPurchasedBooks;

  BookService bookService = BookService();

  String newestBooksQuery = '?sort={"creationDate":-1}&limit=10';
  String bestRatedBooksQuery = '?sort={"currentRating":-1}&limit=10';
  String mostPurchasedBooksQuery = '?sort={"purchasesCount":-1}&limit=10';

  //void fetchDataAndSetState() async {
  //await bookService.fetchDataFromServer(newestBooksQuery, newestBooks);
  //await bookService.fetchDataFromServer(bestRatedBooksQuery, bestRatedBooks);
  //await bookService.fetchDataFromServer(mostPurchasedBooksQuery, mostPurchasedBooks);
  //setState(() {
  // newestBooks;
  // bestRatedBooks;
  //  mostPurchasedBooks;
  // });
//}

//void fetchDataAndSetState() async {
  //newestBooks = bookService.fetchDataFromServer(newestBooksQuery);
  //setState(() {
  // newestBooks;
  // print('init ${newestBooks}');
  //});
//}

  @override
  void initState() {
    super.initState();
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
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
            child: Column(
          children: [
            BookList(
                books:
                    bookService.fetchBooksFromServer(query: newestBooksQuery),
                header: 'Newest Books'),
            BookList(
              books:
                  bookService.fetchBooksFromServer(query: bestRatedBooksQuery),
              header: 'Best Rated Books',
            ),
            BookList(
                books: bookService.fetchBooksFromServer(
                    query: mostPurchasedBooksQuery),
                header: 'Most Purchased Books')
          ],
        ))
      );

  }
}
