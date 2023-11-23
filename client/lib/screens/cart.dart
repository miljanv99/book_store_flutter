import 'package:book_store_flutter/models/cart.model.dart';
import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/book.model.dart';
import '../models/serverResponse.model.dart';
import '../models/user.model.dart';

class CartScreen extends StatefulWidget {
  final String token;
  const CartScreen({Key? key, required this.token}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<CartScreen> {
  late final Future<dynamic> cartData;
  CartService cartService = CartService();

  @override
  Widget build(BuildContext context) {
    Future<Cart> cart = getCartData(widget.token);
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
          } else if (snapshot.data!.totalPrice != 0) {
            print('SNAPSHOT: ${snapshot.data!.user}');
            num? totalPrice = snapshot.data!.totalPrice;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: ListView.builder(
                  itemCount: snapshot.data!.books!.length,
                  itemBuilder: (context, index) {
                    Book book = snapshot.data!.books![index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,
                              height: 120,
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
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text('by ${book.author}'),
                                  SizedBox(height: 8),
                                  Text('Genre: ${book.genre}'),
                                  SizedBox(height: 8),
                                  Text(
                                    '\$${book.price!.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                            onPressed: () => {},
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
