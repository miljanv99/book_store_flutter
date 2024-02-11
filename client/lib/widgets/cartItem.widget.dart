import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:flutter/material.dart';

import '../models/book.model.dart';
import '../services/cart.service.dart';

class CartItemWidget extends StatefulWidget {
  final Book book;
  final AuthorizationProvider authorizationProvider;
  final Map<String, int> bookQuantities;
  final Function onDismiss;
  final Function changeQuantity;
  const CartItemWidget(
      {Key? key, required this.book, required this.authorizationProvider, required this.onDismiss, required this.changeQuantity, required this.bookQuantities})
      : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  CartService cartService = CartService();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Dismissible(
        key: Key(widget.book.id!), //unique key for each item
        direction: DismissDirection.endToStart,
        onDismissed: (direction) async {
          widget.onDismiss();
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          color: Colors.red,
          child: const Icon(
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
                    image: NetworkImage(widget.book.cover!),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.book.title!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('by ${widget.book.author}'),
                    const SizedBox(height: 8),
                    Text('Genre: ${widget.book.genre}'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${widget.book.price!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Row(
                          children: [
                            const Text('Qty:'),
                            const SizedBox(width: 5),
                            Container(
                                margin: const EdgeInsets.only(right: 15),
                                child: DropdownButton<int>(
                                  value: widget.bookQuantities[widget.book.id!] ?? 1,
                                  items: List.generate(9, (index) => index + 1)
                                      .map((int value) {
                                    return DropdownMenuItem<int>(
                                      alignment: Alignment.center,
                                      value: value,
                                      child: Text(value.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (selectedQuantity) {
                                   widget.changeQuantity(selectedQuantity, widget.bookQuantities);
                                  },
                                )),
                            const Icon(
                                Icons.keyboard_double_arrow_left_rounded),
                            const Icon(
                              Icons.delete_rounded,
                              color: Colors.red,
                            ),
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
  }
}
