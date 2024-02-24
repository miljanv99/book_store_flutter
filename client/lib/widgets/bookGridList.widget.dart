import 'package:book_store_flutter/models/book.model.dart';
import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/providers/screenProvider.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:book_store_flutter/widgets/bookGridItem.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class BookGridWidget extends StatefulWidget {
  final List<Book> books;
  final AuthorizationProvider authorizationProvider;
  BookGridWidget(
      {Key? key, required this.books, required this.authorizationProvider})
      : super(key: key);

  CartService cartService = CartService();

  @override
  _BookGridWidgetState createState() => _BookGridWidgetState();
}

class _BookGridWidgetState extends State<BookGridWidget> {
  UserService userService = UserService();
  Book book = Book();
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthorizationProvider, BookDetailsScreensProvider>(
      builder: (context, authNotifier, bookDetailsProvider ,child) {
        return Scaffold(
          body: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 1 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10),
              itemCount: widget.books.length,
              itemBuilder: (BuildContext context, index) {
                book = widget.books[index];
                return BookGridItemWidget(book: book, authNotifier: authNotifier, bookDetailsScreensProvider: bookDetailsProvider);
              }),
        );
      },
    );
  }
}
