import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:book_store_flutter/widgets/snackBar.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/book.model.dart';
import '../models/serverResponse.model.dart';
import '../screens/bookDetails.dart';

class BookGridItemWidget extends StatefulWidget {
  final Book book;
  final AuthorizationProvider authNotifier;
  BookGridItemWidget({Key? key, required this.book, required this.authNotifier}) : super(key: key);

  CartService cartService = CartService();

  @override
  _BookGridItemWidgetState createState() => _BookGridItemWidgetState();
}

class _BookGridItemWidgetState extends State<BookGridItemWidget> {
  UserService userService = UserService();
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        child: GridTile(
          header: GridTileBar(
            backgroundColor: Colors.blueAccent,
            title: Text(widget.book.author ?? ''),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.blueAccent,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('\$${widget.book.price.toString()}'),
                Text(widget.book.genre ?? ''),
              ],
            ),
            trailing: Container(
              height: 30,
              width: 30,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.authNotifier.token == '') {
                    SnackBarNotification.show(
                        context, 'You have to login!', Colors.red);
                  } else {
                    checkAndAddBookToCart(widget.authNotifier.token, widget.book.id!);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(0), // Remove padding
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          child: Image.network(widget.book.cover.toString()),
        ),
      ),
      onTap: () async{
        if (widget.authNotifier.authenticated) {
          await checkIfBookIsFavorite(widget.authNotifier);
        }

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookDetails(
                      bookID: widget.book.id.toString(),
                      authNotifier: widget.authNotifier,
                      isFavorite: isFavorite,
                    )));
      },
    );
  }

    void checkAndAddBookToCart(String token, String bookId) async {
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
        if (book.id == widget.book.id) {
          isFavorite = true;
          break; // No need to continue checking if book is already found
        }
      }
    }
  }
}
