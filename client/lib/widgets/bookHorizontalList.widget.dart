import 'package:book_store_flutter/models/book.model.dart';
import 'package:flutter/material.dart';

import 'bookCard.widget.dart';

class BookList extends StatelessWidget {
  final Future<List<Book>> books;
  final String header;

 
  const BookList({super.key, required this.books, required this.header});

  @override
  Widget build(BuildContext context) {
        return Column(
          children: [
            const Padding(padding: EdgeInsets.all(5)),
              Text(
              header,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FutureBuilder<List<Book>>(
                    future: books,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.data != null) {
                        return Row(
                          children: snapshot.data!.map((book) {
                            return BookCard(book: book);
                          }).toList(),
                        );
                      } else {
                        return const Text('No Data');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
  }
}
