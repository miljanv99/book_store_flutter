import 'package:book_store_flutter/models/book.model.dart';
import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/screens/bookDetails.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:book_store_flutter/widgets/bookGridItem.widget.dart';
import 'package:book_store_flutter/widgets/snackBar.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/serverResponse.model.dart';

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
    return Consumer<AuthorizationProvider>(
      builder: (context, authNotifier, child) {
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
                return BookGridItemWidget(book: book, authNotifier: authNotifier);
              }),
        );
      },
    );
  }

  Future<void> checkAndAddBookToCart(String token, String bookId) async {
    AuthorizationProvider provider = Provider.of(context, listen: false);
    // Get the current cart
    ServerResponse cartResponse = await widget.cartService.getCart(token);

    // Check if the book is already in the cart
    bool isBookInCart = false;
    if (cartResponse.data != null && cartResponse.data['books'] is List) {
      List<dynamic> cartItems = cartResponse.data['books'];
      isBookInCart = cartItems.any((item) => item['_id'] == bookId);
    }

    // Add the book to the cart if it's not already present
    if (!isBookInCart) {
      ServerResponse addToCartResponse =
          await widget.cartService.addBookToCart(token, bookId);
      print('Add to cart response ${addToCartResponse.message}');
      SnackBarNotification.show(
          context, 'You added book to cart', Colors.green);
      provider.cartSize++;
    } else {
      print('The book is already in the cart.');
      SnackBarNotification.show(
          context, 'The book is already in the cart', Colors.red);
    }
  }

  Future<void> checkIfBookIsFavorite(AuthorizationProvider authNotifier) async {
    ServerResponse responseData;
    responseData =
        await userService.getProfile(authNotifier.username, authNotifier.token);

    // Assuming 'favoriteBooks' is a list of dynamic
    List<dynamic>? favoriteBooksData = responseData.data['favoriteBooks'];

    if (favoriteBooksData != null) {
      for (var i = 0; i < favoriteBooksData.length; i++) {
        Book book = Book.fromJson(favoriteBooksData[i]);
        if (book.id == book.id) {
          isFavorite = true;
          break; // No need to continue checking if book is already found
        }
      }
    }
  }
}
