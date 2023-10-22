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
      height: 300,
      child: Card(
      elevation: 4, // Adjust the shadow of the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Set border radius
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
            child: Image.network(
              imageUrl,
              fit: BoxFit.fill,
              width: 250,
              height: 200, // Set the desired height for the image
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.0),
                Text(
                  author,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}
