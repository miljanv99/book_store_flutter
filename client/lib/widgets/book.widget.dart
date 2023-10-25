import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;

  BookCard({required this.title, required this.author, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                imageUrl,
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
                        title,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        author,
                        style: TextStyle(fontSize: 14.0, color: Colors.grey),
                      ),
                      SizedBox(height: 4.0),
                      ElevatedButton(
                          style: ButtonStyle(),
                          onPressed: () => {print(title)},
                          child: Text('Add to cart'))
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
