import 'package:book_store_flutter/screens/bookDetails.dart';
import 'package:book_store_flutter/services/book.service.dart';
import 'package:flutter/material.dart';
import '../models/book.model.dart';

class BookCard extends StatelessWidget {
  final Book book;

  BookService bookService = BookService();

  BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 250,
        height: 350,
        child: Card(
          elevation: 4, // Adjust the shadow of the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Set border radius
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                child: Image.network(
                  book.cover.toString(),
                  fit: BoxFit.fill,
                  width: 250,
                  height: 220,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          book.title.toString(),
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          book.author.toString(),
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                        SizedBox(height: 4.0),
                        ElevatedButton(
                            style: ButtonStyle(),
                            onPressed: () => {print(book.title)},
                            child: Text('Add to cart'))
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
      onTap: (){
        print(book.id);
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context)=> BookDetails(bookID: book.id.toString()))
        );
      },
    );
  }
}
