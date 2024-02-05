import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:book_store_flutter/widgets/snackBar.widget.dart';
import 'package:flutter/material.dart';
import '../models/book.model.dart';
import '../screens/bookDetails.dart';
import '../utils/globalMethods.dart';
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
  GlobalMethods globalMethods = GlobalMethods();
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
                    globalMethods.checkAndAddBookToCart(widget.authNotifier, widget.book.id!, context, widget.cartService);
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
          isFavorite = await globalMethods.checkIfBookIsFavorite(widget.authNotifier, userService, widget.book);
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
}
