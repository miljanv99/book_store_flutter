import 'package:book_store_flutter/models/receipt.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/book.model.dart';

class PurchaseHistoryItemWidget extends StatefulWidget {
  final Receipt receipt;
  final List<Book> books;
  const PurchaseHistoryItemWidget(
      {Key? key, required this.receipt, required this.books})
      : super(key: key);

  @override
  _PurchaseHistoryItemWidgetState createState() =>
      _PurchaseHistoryItemWidgetState();
}

class _PurchaseHistoryItemWidgetState extends State<PurchaseHistoryItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
              title: Text(
                'Receipt ID: ${widget.receipt.id}',
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              subtitle: Center(
                child: Text(
                  'Total Price: \$${widget.receipt.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.blueAccent),
                ),
              )),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.books.length,
            itemBuilder: (context, bookIndex) {
              Book book = widget.books[bookIndex];
              return ListTile(
                leading: Image.network(
                  book.cover ?? '',
                  width: 60,
                  height: 80,
                ),
                title: Text(
                  '${book.title}',
                  style:
                      const TextStyle(fontSize: 16, color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                ),
                subtitle: Column(
                  children: [
                    Text('Quantity: ${book.price} x ${book.qty}'),
                    Text('Author: ${book.author}')
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
