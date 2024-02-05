import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:flutter/material.dart';
import '../models/book.model.dart';
import '../models/serverResponse.model.dart';
import '../providers/authentication.provider.dart';
import '../widgets/snackBar.widget.dart';

class GlobalMethods {
   void checkAndAddBookToCart(AuthorizationProvider authProvider , String bookId, BuildContext context, CartService cartService) async {
    
    // Get the current cart
    ServerResponse cartResponse = await cartService.getCart(authProvider.token);

    // Check if the book is already in the cart
    bool isBookInCart = false;
    if (cartResponse.data != null && cartResponse.data['books'] is List) {
      List<dynamic> cartItems = cartResponse.data['books'];
      isBookInCart = cartItems.any((item) => item['_id'] == bookId);
    }

    // Add the book to the cart if it's not already present
    if (!isBookInCart) {
      ServerResponse addToCartResponse =
          await cartService.addBookToCart(authProvider.token, bookId);
      print('Add to cart response ${addToCartResponse.message}');
      SnackBarNotification.show(
          context, 'You added book to cart', Colors.green);
      authProvider.cartSize++;
    } else {
      print('The book is already in the cart.');
      SnackBarNotification.show(
          context, 'The book is already in the cart', Colors.red);
    }
  }

  Future<bool> checkIfBookIsFavorite(AuthorizationProvider authNotifier, UserService userService, Book book) async {
    ServerResponse responseData;
    responseData =
        await userService.getProfile(authNotifier.username, authNotifier.token);

    // Assuming 'favoriteBooks' is a list of dynamic
    List<dynamic> favoriteBooksData = responseData.data['favoriteBooks'];

    if (favoriteBooksData.isNotEmpty) {
      for (var i = 0; i < favoriteBooksData.length; i++) {
        Book bookItem = Book.fromJson(favoriteBooksData[i]);
        if (bookItem.id == book.id) {
          return true;
        }
      }
    }
    return false;
  }
  
}