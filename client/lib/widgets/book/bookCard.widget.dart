import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/providers/screenProvider.dart';
import 'package:book_store_flutter/widgets/book/bookDetails.dart';
import 'package:book_store_flutter/screens/bookDetailsAndComments.dart';
import 'package:book_store_flutter/services/book.service.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:book_store_flutter/widgets/snackBar.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book.model.dart';
import '../../utils/globalMethods.dart';

class BookCard extends StatefulWidget {
  final Book book;
  BookCard({Key? key, required this.book}) : super(key: key);

  CartService cartService = CartService();

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  BookService bookService = BookService();
  CartService cartService = CartService();
  UserService userService = UserService();
  GlobalMethods globalMethods = GlobalMethods();
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthorizationProvider, BookDetailsScreensProvider>(
      builder: (context, authNotifier, bookDetailsProvider, child) {
        return GestureDetector(
          child: SizedBox(
            width: 250,
            height: 350,
            child: Card(
              elevation: 4, // Adjust the shadow of the card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Set border radius
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(widget.book.cover ?? ''),
                            fit: BoxFit.fill)),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            widget.book.title.toString(),
                            style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            widget.book.author.toString(),
                            style: const TextStyle(
                                fontSize: 14.0, color: Colors.grey),
                          ),
                          const SizedBox(height: 4.0),
                          ElevatedButton(
                              style: const ButtonStyle(),
                              onPressed: () => {
                                    if (authNotifier.token == '')
                                      {
                                        SnackBarNotification.show(context,
                                            'You have to login!', Colors.red)
                                      }
                                    else
                                      {
                                        globalMethods.checkAndAddBookToCart(
                                            authNotifier,
                                            widget.book.id!,
                                            context,
                                            cartService)
                                      }
                                  },
                              child: const Text('Add to cart'))
                        ],
                      )),
                ],
              ),
            ),
          ),
          onTap: () async {
            print(widget.book.id);
            if (authNotifier.authenticated) {
              isFavorite = await globalMethods.checkIfBookIsFavorite(
                  authNotifier, userService, widget.book);
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookDetailsAndComments(
                          book: widget.book,
                          authNotifier: authNotifier,
                          isFavorite: isFavorite,
                          bookDetailsScreensProvider: bookDetailsProvider,
                        )));        
          },
        );
      },
    );
  }
}
