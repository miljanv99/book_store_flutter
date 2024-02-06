import 'package:book_store_flutter/models/book.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'bookCard.widget.dart';

class BookList extends StatelessWidget {
  final Future<List<Book>> books;
  final String header;

  const BookList({Key? key, required this.books, required this.header})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.all(5)),
        Text(
          header,
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        !kIsWeb && Platform.isAndroid 
            ? SingleChildScrollView(
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
              )
            : FutureBuilder<List<Book>>(
                future: books,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data != null) {
                    return Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing:
                            8.0, // Adjust the spacing between items as needed
                        runSpacing: 8.0, // Adjust the run spacing as needed
                        children: snapshot.data!.map((book) {
                          return BookCard(book: book);
                        }).toList(),
                      ),
                    );
                  } else {
                    return const Text('No Data');
                  }
                },
              ),
      ],
    );
  }
}
