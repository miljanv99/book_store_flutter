import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/services/book.service.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:book_store_flutter/utils/globalMethods.dart';
import 'package:book_store_flutter/widgets/bookDetails.widget.dart';
import 'package:flutter/material.dart';
import '../models/book.model.dart';

class BookDetails extends StatefulWidget {
  final String bookID;
  //final String token;
  final AuthorizationProvider authNotifier;
  bool isFavorite;
  BookDetails({
    Key? key,
    required this.bookID,
    required this.authNotifier,
    required this.isFavorite,
  }) : super(key: key);

  BookService bookService = BookService();
  CartService cartService = CartService();
  GlobalMethods globalMethods = GlobalMethods();

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  BookService bookService = BookService();
  UserService userService = UserService();
  @override
  Widget build(BuildContext context) {
    print('BEFORE: ${widget.isFavorite}');

    return Scaffold(
          body: FutureBuilder(
            future: widget.bookService.getSingleBook(widget.bookID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data != null) {
                Book book = snapshot.data!;
                return SingleChildScrollView(
                    child: Center(
                  child: Column(children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        BookDetailsWidget(
                            authNotifier: widget.authNotifier, book: book)
                      ],
                    ),
                  ]),
                ));
              } else {
                return const Text('No Data');
              }
            },
          ),
        );
  }
}
