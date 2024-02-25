import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:flutter/material.dart';

class CartBadgeCounterWidget extends StatefulWidget {
  final AuthorizationProvider authorizationProvider;
  const CartBadgeCounterWidget(
      {Key? key, required this.authorizationProvider})
      : super(key: key);

  @override
  _CartBadgeCounterWidgetState createState() =>
      _CartBadgeCounterWidgetState();
}

class _CartBadgeCounterWidgetState
    extends State<CartBadgeCounterWidget> {
  @override
  Widget build(BuildContext context) {
    String cartSizeValue = widget.authorizationProvider.cartSize > 9
        ? '9+'
        : widget.authorizationProvider.cartSize.toString();
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      constraints: const BoxConstraints(
        minWidth: 16,
        minHeight: 16,
      ),
      child: Text(
        cartSizeValue,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
