import 'package:book_store_flutter/models/book.model.dart';
import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/screens/bookDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookGridView extends StatelessWidget {
  final List<Book> books;

  const BookGridView({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthorizationProvider>(
      builder: (context, authNotifier, child) {
        return Scaffold(
          body: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 1 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10),
              itemCount: books.length,
              itemBuilder: (BuildContext context, index) {
                Book book = books[index];
                return GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    child: GridTile(
                      header: GridTileBar(
                        backgroundColor: Colors.blueAccent,
                        title: Text(book.author ?? ''),
                      ),
                      footer: GridTileBar(
                        backgroundColor: Colors.blueAccent,
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('\$${book.price.toString()}'),
                            Text(book.genre ?? ''),
                          ],
                        ),
                        trailing: Container(
                          height: 30,
                          width: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              // Add to cart logic here
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(0), // Remove padding
                            ),
                            child: const Center(
                              child: Icon(Icons.add,
                                  size: 20), // Adjust the size of the icon
                            ),
                          ),
                        ),
                      ),
                      child: Image.network(book.cover.toString()),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookDetails(
                                  bookID: book.id.toString(),
                                  authNotifier: authNotifier,
                                )));
                  },
                );
              }),
        );
      },
    );
  }
}
