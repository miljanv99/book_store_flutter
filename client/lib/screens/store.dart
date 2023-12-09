import 'package:book_store_flutter/models/book.model.dart';
import 'package:book_store_flutter/providers/authentication.provider.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthorizationProvider>(
      builder: (context, authNotifier, child) {
        return Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                  future: bookService.fetchBooksFromServer(),
                  builder: (context, AsyncSnapshot<List<Book>> snap) {
                    if (snap.connectionState == ConnectionState.done) {
                      List<Book> books = snap.data ?? [];
                      print(books.length);
                      return Expanded(
                          child: BookGridWidget(
                        books: books,
                        authorizationProvider: authNotifier,
                      ));
                    } else {
                      return const LinearProgressIndicator();
                    }
                  }),
            ],
          ),
        );
      },
    );
  }
}
