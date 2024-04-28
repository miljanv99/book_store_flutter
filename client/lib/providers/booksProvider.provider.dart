import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/book.model.dart';
import '../services/book.service.dart';


class BooksProvider extends ChangeNotifier {

  String newestBooksQuery = '?sort={"creationDate":-1}&limit=10';
  String bestRatedBooksQuery = '?sort={"currentRating":-1}&limit=10';
  String mostPurchasedBooksQuery = '?sort={"purchasesCount":-1}&limit=10';

  BookService bookService = BookService();

  late final Future<List<Book>> _newestBooks= bookService.fetchBooksFromServer(query: newestBooksQuery);
  Future <List<Book>> get newestBooks => _newestBooks;

  late final Future<List<Book>> _bestRatedBooks = bookService.fetchBooksFromServer(query: bestRatedBooksQuery);
  Future <List<Book>> get bestRatedBooks => _bestRatedBooks;

  late final Future<List<Book>> _mostPurchasedBooks = bookService.fetchBooksFromServer(query: mostPurchasedBooksQuery);
  Future <List<Book>> get mostPurchasedBooks => _mostPurchasedBooks;

  late final Future<List<Book>> _allBooks = bookService.fetchBooksFromServer();
  Future<List<Book>> get allBooks => _allBooks;

}
