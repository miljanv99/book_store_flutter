import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/widgets/user/purchaseHistoryItem.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.model.dart';
import '../models/receipt.model.dart';
import '../utils/screenWidth.dart';

class PurchaseHistory extends StatefulWidget {
  const PurchaseHistory({Key? key}) : super(key: key);

  @override
  _PurchaseHistoryState createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  Future<List<Receipt>>? receipts;
  @override
  Widget build(BuildContext context) {
    double maxWidth = calculateMaxWidth(context);
    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text('Your Purchase History'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
        ),
        body: Center(
          child: Container(
            width: maxWidth,
            child: Consumer<AuthorizationProvider>(
              builder: (context, authNotifier, child) {
                String token = authNotifier.token;
                receipts = authNotifier.updatePurchaseHistory(token);
                return FutureBuilder(
                  future: receipts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.data!.isEmpty) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history_rounded),
                          SizedBox(height: 10),
                          Text('No purchase history')
                        ],
                      );
                    } else {
                      List<Receipt> receiptList = snapshot.data!;

                      return ListView.builder(
                        itemCount: receiptList.length,
                        itemBuilder: (context, index) {
                          Receipt receipt = receiptList[index];
                          List<Book> books = receipt.productsInfo;

                          return PurchaseHistoryItemWidget(
                              receipt: receipt, books: books);
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
        ));
  }
}
