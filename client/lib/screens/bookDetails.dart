import 'package:book_store_flutter/services/book.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/book.model.dart';

class BookDetails extends StatefulWidget {
  final String bookID;
  BookDetails({Key? key, required this.bookID}) : super(key: key);

  BookService bookService = BookService();

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double maxPhoneWidth = 600.0;

    double maxWidth = screenWidth < maxPhoneWidth ? screenWidth : maxPhoneWidth;

    return Scaffold(
      appBar: AppBar(
        titleTextStyle: const TextStyle(fontSize: 15, color: Colors.white),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: FutureBuilder(
          future: widget.bookService.getSingleBook(widget.bookID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data != null) {
              String bootTitle = snapshot.data!.title.toString();
              return Text(bootTitle);
            } else {
              return const Text('No Data');
            }
          },
        ),
      ),
      body: FutureBuilder(
        future: widget.bookService.getSingleBook(widget.bookID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data != null) {
            Book book = snapshot.data!;
            return SingleChildScrollView(
                child: Center(
              child: Column(children: <Widget>[
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Container(
                      width: maxWidth,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 500,
                            width: 500,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(book.cover ?? ''),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            book.title ?? 'Title not available',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Author: ${book.author ?? 'Author not available'}',
                            style: TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                color: Colors.blueAccent),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Genre: ${book.genre ?? 'Genre not available'}',
                            style: TextStyle(
                                fontSize: 18, color: Colors.blueAccent),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Year: ${book.year ?? 'Year not available'}',
                            style: TextStyle(
                                fontSize: 18, color: Colors.blueAccent),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Description:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            book.description ?? 'Description not available',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pages: ${book.pagesCount ?? 'N/A'}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.blueAccent),
                              ),
                              Text(
                                'Price: \$${book.price ?? 'N/A'}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.blueAccent),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Add functionality here for purchasing the book
                            },
                            child: Text('Buy Now'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
            ));
          } else {
            return Text('No Data');
          }
        },
      ),
    );
  }
}
