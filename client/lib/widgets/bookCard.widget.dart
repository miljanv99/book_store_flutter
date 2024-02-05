import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/screens/bookDetails.dart';
import 'package:book_store_flutter/services/book.service.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:book_store_flutter/widgets/snackBar.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.model.dart';
import '../models/serverResponse.model.dart';
import '../models/user.model.dart';
import '../utils/globalMethods.dart';

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
    return Consumer<AuthorizationProvider>(
      builder: (context, authNotifier, child) {
        return GestureDetector(
          child: Container(
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
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              widget.book.title.toString(),
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              widget.book.author.toString(),
                              style:
                                  TextStyle(fontSize: 14.0, color: Colors.grey),
                            ),
                            SizedBox(height: 4.0),
                            ElevatedButton(
                                style: ButtonStyle(),
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
                                              widget.book.id!, context, cartService)
                                        }
                                    },
                                child: Text('Add to cart'))
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
          onTap: () async {
            print(widget.book.id);
            if (authNotifier.authenticated) {
              isFavorite = await globalMethods.checkIfBookIsFavorite(authNotifier, userService, widget.book);
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookDetails(
                          bookID: widget.book.id.toString(),
                          authNotifier: authNotifier,
                          isFavorite: isFavorite,
                        )));
          },
        );
      },
    );
  }
}
