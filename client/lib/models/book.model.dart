
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
 int? qty;
 DateTime? creationDate;
 double? currentRating;
 int? ratingPoints;
 int? ratedCount;
 int? purchaseCount;
 //comments? Comment[];

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
     this.qty,
     this.creationDate,
     this.currentRating,
     this.ratingPoints,
     this.ratedCount,
     this.purchaseCount,
     //this.comments
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
      qty = json['qty'];
      if (json['creationDate'] != null) {
        creationDate = DateTime.parse(json['creationDate']);
      }
      if (json['currentRating'] != null) {
        currentRating = json['currentRating'].toDouble();
      }
      ratingPoints = json['ratingPoints'];
      ratedCount = json['ratedCount'];
      purchaseCount = json['purchaseCount'];
      //comments = json['comments'];
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
      'qty': qty,
      'creationDate': creationDate,
      'currentRating': currentRating,
      'ratingPoints': ratingPoints,
      'ratedCount': ratedCount,
      'purchaseCount': purchaseCount,
      //'comments': comments
    };
 }
}