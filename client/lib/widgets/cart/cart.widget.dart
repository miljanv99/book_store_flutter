import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/widgets/cart/cartBadgeCounter.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../screens/cart.dart';

class CartWidget extends StatefulWidget {
  final AuthorizationProvider authorizationProvider;
  const CartWidget({Key? key, required this.authorizationProvider})
      : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Consumer<AuthorizationProvider>(
          builder: (context, authProvider, child) {
            print('TOKEN ON CART ICON; ${authProvider.token}');
            return Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CartScreen(authorizationProvider: authProvider)));
                  },
                  icon: const Icon(Icons.shopping_cart_rounded),
                  iconSize: 28,
                  color: Colors.white,
                ),
                Positioned(
                    right: 0,
                    top: 0,
                    child: CartBadgeCounterWidget(
                        authorizationProvider: widget.authorizationProvider)),
              ],
            );
          },
        ));
  }
}
