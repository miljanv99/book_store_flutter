import 'package:book_store_flutter/providers/booksProvider.provider.dart';
import 'package:book_store_flutter/widgets/book/bookHorizontalList.widget.dart';
import 'package:flutter/material.dart';
import '../models/book.model.dart';
import '../services/book.service.dart';

class Home extends StatefulWidget {
  final BooksProvider booksProvider;
  const Home({Key? key, required this.booksProvider, }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Book>> newestBooks;
  late Future<List<Book>> bestRatedBooks;
  late Future<List<Book>> mostPurchasedBooks;

  BookService bookService = BookService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        return Container(
        padding: const EdgeInsets.all(5),
        child: SingleChildScrollView(
            child: Column(
          children: [
            BookList(
                books:
                    widget.booksProvider.newestBooks,
                header: 'Newest Books'),
            BookList(
              books:
                    widget.booksProvider.bestRatedBooks,
              header: 'Best Rated Books',
            ),
            BookList(
                books: widget.booksProvider.mostPurchasedBooks,
                header: 'Most Purchased Books')
          ],
        ))
      );

  }
}
