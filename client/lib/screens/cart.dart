import 'package:book_store_flutter/models/cart.model.dart';
import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/book.model.dart';
import '../models/serverResponse.model.dart';
import '../models/user.model.dart';
import '../widgets/snackBar.widget.dart';

class CartScreen extends StatefulWidget {
  final AuthorizationProvider authorizationProvider;
  const CartScreen({Key? key, required this.authorizationProvider})
      : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<CartScreen> {
  late final Future<dynamic> cartData;
  CartService cartService = CartService();
  late String bookID;
  late List<Book> bookList;
  Map<String, int> bookInfo = {};

  @override
  Widget build(BuildContext context) {
    Future<Cart> cart = getCartData(widget.authorizationProvider.token);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Cart Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: cart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.books!.isNotEmpty) {
            print('SNAPSHOT: ${snapshot.data!.user}');
            num? totalPrice = snapshot.data!.totalPrice;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: ListView.builder(
                  itemCount: snapshot.data!.books!.length,
                  itemBuilder: (context, index) {
                    bookList = snapshot.data!.books!;
                    Book book = snapshot.data!.books![index];
                    bookID = book.id!;
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Dismissible(
                        key: Key(book.id!), //unique key for each item
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            await cartService.removeBookFromCart(
                                widget.authorizationProvider.token, book.id!);
                            await widget.authorizationProvider.cartSize--;
                            setState(() {
                              totalPrice = totalPrice! - book.price!;
                            });
                          }
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.0),
                          color: Colors.red,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 90,
                                height: 130,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(book.cover!),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.title!,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text('by ${book.author}'),
                                    SizedBox(height: 8),
                                    Text('Genre: ${book.genre}'),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${book.price!.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.keyboard_double_arrow_left_rounded),
                                            Icon(
                                              Icons.delete_rounded,
                                              color: Colors.red,
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Total Price:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$${totalPrice!.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              for (Book book in bookList) {
                                bookInfo[book.id!] = 1;
                              }

                              String message;
                              message = await cartService.checkout(
                                  widget.authorizationProvider.token, bookInfo);

                              print('THIS IS BOOK: ${bookID}');
                              print('MESSAGE: ${message}');

                              SnackBarNotification.show(context, '$message', Colors.green);

                              widget.authorizationProvider.cartSize = 0;

                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.shopping_cart_checkout_rounded),
                                Text('Checkout')
                              ],
                            ))
                      ],
                    )),
              ],
            );
          } else {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.remove_shopping_cart, size: 100),
                Text('You`re shopping cart is empty')
              ],
            ));
          }
        },
      ),
    );
  }

  Future<Cart> getCartData(String token) async {
    ServerResponse serverResponse = await cartService.getCart(token);

    Cart cartData = Cart.fromJson(serverResponse.data);

    return cartData;
  }
}
