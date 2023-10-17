import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
 late final String cover;
 late final String title;
 late final String author;
 late final double price;
 late final String id;


 @override
 Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(cover),
          ListTile(
            title: Text(title),
            subtitle: Text('Author: $author'),
            trailing: Text('\$$price'),
          ),
          ButtonBar(
            children: [
              TextButton(
                onPressed: () {
                 Navigator.pushNamed(context, '/book/details/$id');
                },
                child: Text('View Details'),
              ),
            ],
          ),
        ],
      ),
    );
 }
}