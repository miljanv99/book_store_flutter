
import 'package:flutter/material.dart';

class Book {
 String? id;
 String? title;
 String? author;
 String? genre;
 int? year;
 String? description;
 String? cover;
 String? isbn;
 int? pagesCount;
 double? price;

 Book({
     this.id,
     this.title,
     this.author,
     this.genre,
     this.year,
     this.description,
     this.cover,
     this.isbn,
     this.pagesCount,
     this.price,
 });

 Book.fromJson(Map<String, dynamic> json) {
    
      id = json['_id'];
      title = json['title'];
      author = json['author'];
      genre = json['genre'];
      year = json['year'];
      description = json['description'];
      cover = json['cover'];
      isbn = json['isbn'];
      pagesCount = json['pagesCount'];
      price = json['price'].toDouble();

 }

 Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'year': year,
      'description': description,
      'cover': cover,
      'isbn': isbn,
      'pagesCount': pagesCount,
      'price': price,
    };
 }
}