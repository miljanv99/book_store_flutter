import 'package:book_store_flutter/models/book.model.dart';
import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/screens/bookDetails.dart';
import 'package:book_store_flutter/services/cart.service.dart';
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
                Book book = widget.books[index];
                return GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    child: GridTile(
                      header: GridTileBar(
                        backgroundColor: Colors.blueAccent,
                        title: Text(book.author ?? ''),
                      ),
                      footer: GridTileBar(
                        backgroundColor: Colors.blueAccent,
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('\$${book.price.toString()}'),
                            Text(book.genre ?? ''),
                          ],
                        ),
                        trailing: Container(
                          height: 30,
                          width: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              if (authNotifier.token == '') {
                                SnackBarNotification.show(
                                    context,
                                    'You have to login!',
                                    Colors.red);
                              } else {
                                checkAndAddBookToCart(
                                    authNotifier.token, book.id!);
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
                      child: Image.network(book.cover.toString()),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookDetails(
                                  bookID: book.id.toString(),
                                  authNotifier: authNotifier,
                                )));
                  },
                );
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
      SnackBarNotification.show(context, 'You added book to cart', Colors.green);
      provider.cartSize++;
    } else {
      print('The book is already in the cart.');
      SnackBarNotification.show(context, 'The book is already in the cart', Colors.red);
    }
  }
}
