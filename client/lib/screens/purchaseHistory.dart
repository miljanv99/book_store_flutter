import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/book.model.dart';
import '../models/receipt.model.dart';
import '../providers/authentication.provider.dart';

class PurchaseHistory extends StatefulWidget {
  const PurchaseHistory({Key? key}) : super(key: key);

  @override
  _PurchaseHistoryState createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  late final Future<List<Receipt>> receipts;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text('Your Purchase History'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold, 
          color: Colors.black,
          fontSize: 24
          ),
      ),
      body: Consumer<AuthorizationProvider>(
        builder: (context, authNotifier, child) {
          if (authNotifier.authenticated) {
            String token = authNotifier.token;
            receipts = authNotifier.updatePurchaseHistory(token);
            return FutureBuilder(
              future: receipts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  List<Receipt> receiptList = snapshot.data!;

                  return ListView.builder(
                    itemCount: receiptList.length,
                    itemBuilder: (context, index) {
                      Receipt receipt = receiptList[index];
                      List<Book> books = receipt.productsInfo!;

                      return Card(
                        elevation: 5,
                        margin: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                                title: Text(
                                  'Receipt ID: ${receipt.id}',
                                  style: TextStyle(fontSize: 15),
                                ),
                                subtitle: Center(
                                  child: Text(
                                    'Total Price: \$${receipt.totalPrice}',
                                    style: const TextStyle(
                                        color: Colors.blueAccent),
                                  ),
                                )),
                            Divider(),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: books.length,
                              itemBuilder: (context, bookIndex) {
                                Book book = books[bookIndex];
                                return ListTile(
                                  leading: Image.network(
                                    book.cover ?? '',
                                    width: 60,
                                    height: 80,
                                  ),
                                  title: Text(
                                    '${book.title}',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.blueAccent),
                                    textAlign: TextAlign.center,
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Text(
                                          'Quantity: ${book.price} x ${book.qty}'),
                                      Text('Author: ${book.author}')
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 8.0),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            );
          } else {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_outlined, size: 80),
                SizedBox(height: 5),
                Text('You do not have any purchase'),
                SizedBox(height: 5),
                Text('Go buy something!')
              ],
            ));
          }
        },
      ),
    );
  }
}
