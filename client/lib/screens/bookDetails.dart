import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/services/book.service.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:book_store_flutter/utils/globalMethods.dart';
import 'package:book_store_flutter/widgets/bookDetails.widget.dart';
import 'package:flutter/material.dart';
import '../models/book.model.dart';
import '../widgets/snackBar.widget.dart';

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

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            titleTextStyle: const TextStyle(fontSize: 15, color: Colors.white),
            backgroundColor: Colors.blueAccent,
            centerTitle: true,
            actions: [
              if (widget.authNotifier.authenticated)
                IconButton(
                  onPressed: () {
                    bookService.addOrRemoveFavouriteBook(
                        widget.authNotifier.token, widget.bookID);
                    setState(() {
                      widget.isFavorite = !widget.isFavorite;
                    });
                    if (widget.isFavorite) {
                      SnackBarNotification.show(context,
                          'The book is added to favorites', Colors.green);
                    } else {
                      SnackBarNotification.show(context,
                          'The book is removed from favorites', Colors.green);
                    }
                  },
                  icon: Icon(
                    widget.isFavorite == true
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 35,
                  ),
                  color: Colors.redAccent,
                ),
            ],
            title: FutureBuilder(
              future: widget.bookService.getSingleBook(widget.bookID),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data != null) {
                  String bootTitle = snapshot.data!.title.toString();
                  return Text(bootTitle);
                } else {
                  return const Text('No Data');
                }
              },
            ),
          ),
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
        ),
        onWillPop: () async {
          widget.isFavorite == false
              ? Navigator.pop(context, true)
              : Navigator.pop(context, false);
          return true;
        });
  }
}
