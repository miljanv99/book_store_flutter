import 'package:book_store_flutter/models/cart.model.dart';
import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/widgets/cart/cartItem.widget.dart';
import 'package:flutter/material.dart';
import '../models/book.model.dart';
import '../models/serverResponse.model.dart';
import '../utils/screenWidth.dart';
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
  late List<Book> bookList;
  Map<String, int> bookInfo = {};
  Map<String, TextEditingController> quantityController = {};
  Map<String, int> bookQuantities = {};
  num totalPrice = 0;

  @override
  void initState() {
    super.initState();
    bookList = [];
  }

  @override
  Widget build(BuildContext context) {
    Future<Cart> cart = getCartData(widget.authorizationProvider.token);
    double maxWidth = calculateMaxWidth(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Cart Screen',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (widget.authorizationProvider.cartSize > 1)
            Container(
              margin: EdgeInsets.only(right: 20),
              child: IconButton(
                  onPressed: () {
                    emptyTheCart(context);
                  },
                  icon: const Text(
                    'Remove All',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )),
            )
        ],
      ),
      body: FutureBuilder(
        future: cart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.books!.isNotEmpty) {
            print('SNAPSHOT: ${snapshot.data!.user}');
            if (totalPrice == 0) {
              totalPrice = snapshot.data!.totalPrice!;
            }
            print('SNAPSHOT TOTAL PRICE: ${totalPrice}');
            return Center(
                child: Container(
              width: maxWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.books!.length,
                      itemBuilder: (context, index) {
                        bookList = snapshot.data!.books!;
                        Book book = snapshot.data!.books![index];
                        return CartItemWidget(
                          book: book,
                          authorizationProvider: widget.authorizationProvider,
                          bookQuantities: bookQuantities,
                          onDismiss: () async {
                            await cartService.removeBookFromCart(
                                widget.authorizationProvider.token, book.id!);
                            widget.authorizationProvider.cartSize--;
                            setState(() {
                              if (bookQuantities[book.id] != null) {
                                totalPrice = totalPrice -
                                    (book.price! * bookQuantities[book.id]!);
                              } else {
                                totalPrice = totalPrice - book.price!;
                              }
                            });
                          },
                          changeQuantity: (selectedQuantity, bookQuantities) {
                            print("quantity book: ${bookQuantities[book.id!]}");
                            totalPrice = 0;

                            setState(() {
                              bookQuantities[book.id!] = selectedQuantity ?? 1;

                              for (Book book in bookList) {
                                int quantity = bookQuantities[book.id!] ?? 1;
                                totalPrice += (book.price! * quantity);
                              }
                              print("POSLE: ${totalPrice}");
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Total Price:',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$${totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () {
                                checkout();
                              },
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.shopping_cart_checkout_rounded),
                                  Text('Checkout')
                                ],
                              )),
                        ],
                      )),
                ],
              ),
            ));
          } else {
            return const Center(
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

  Future<void> checkout() async {
    for (Book book in bookList) {
      bookInfo[book.id!] = bookQuantities[book.id] ?? 1;
    }

    String message;
    message = await cartService.checkout(
        widget.authorizationProvider.token, bookInfo);

    print('MESSAGE: ${message}');

    SnackBarNotification.show(context, '$message', Colors.green);

    widget.authorizationProvider.cartSize = 0;

    Navigator.pop(context);
  }

  Future<void> emptyTheCart(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text(
              "Remove All",
              textAlign: TextAlign.center,
            ),
            content: const Text(
              'Are you sure that you want to empty your cart?',
              textAlign: TextAlign.center,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Yes'),
                    onPressed: () {
                      Future<ServerResponse> serverResponse =
                          cartService.removeAllFromCart(
                              widget.authorizationProvider.token);
                      Navigator.of(context).pop();
                      widget.authorizationProvider.cartSize = 0;

                      serverResponse.then((response) {
                        SnackBarNotification.show(
                            context, response.message, Colors.green);
                        setState(() {});
                      }).catchError((error) {
                        SnackBarNotification.show(
                            context, '$error', Colors.red);
                      });
                    },
                  ),
                ],
              )
            ]);
      },
    );
  }
}
