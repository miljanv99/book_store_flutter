import 'package:book_store_flutter/widgets/bookHorizontalList.widget.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Future<List<Book>> postsFuture = getPosts();
        return Container(
        padding: const EdgeInsets.all(5),
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
