import 'package:book_store_flutter/models/book.model.dart';
import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/utils/screenWidth.dart';
import 'package:book_store_flutter/widgets/bookGridList.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/book.service.dart';

class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  BookService bookService = BookService();
   List<Book> allBooks = [];
   List<Book> displayedBooks = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final books = await bookService.fetchBooksFromServer();
    setState(() {
      allBooks = books;
      displayedBooks = books;
    });
  }

  void searchBooks(String query) {
    setState(() {
      displayedBooks = allBooks
          .where((book) =>
              book.title!.toLowerCase().contains(query.toLowerCase()) ||
              book.author!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthorizationProvider>(
      builder: (context, authNotifier, child) {
        return Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: maxPhoneWidth,
                child: TextField(
                  onChanged: (query) => searchBooks(query),
                  decoration: const InputDecoration(
                    labelText: 'Search books by: Title/Author',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder(
                future: bookService.fetchBooksFromServer(),
                builder: (context, AsyncSnapshot<List<Book>> snap) {
                  if (snap.connectionState == ConnectionState.done) {
                    List<Book> books = displayedBooks;
                    print(books.length);
                    if (books.isNotEmpty) {
                      return Expanded(
                        child: BookGridWidget(
                          books: books,
                          authorizationProvider: authNotifier,
                        ),
                      );
                    } else {
                      return const Column(
                        children: [
                          Text('There is no book by that title/author'),
                          Icon(
                            Icons.dangerous_rounded,
                            size: 52,
                          )
                        ],
                      );
                    }
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
