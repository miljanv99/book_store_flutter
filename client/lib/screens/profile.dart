import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/widgets/book.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/book.model.dart';
import '../models/serverResponse.model.dart';
import '../models/user.model.dart';
import 'bookDetails.dart';

class Profile extends StatefulWidget {
  final User userProfileData;
  final AuthorizationProvider authNotifier;

  const Profile(
      {Key? key, required this.userProfileData, required this.authNotifier})
      : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<dynamic>? favoriteBooks;
  CartService cartService = CartService();
  @override
  Widget build(BuildContext context) {
    print("PROFILE BOOKS: ${widget.userProfileData.favoriteBooks}");
    bool isAdmin = widget.userProfileData.isAdmin!;
    favoriteBooks = widget.userProfileData.favoriteBooks;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.blueAccent,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 26),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
              child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 4.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage('${widget.userProfileData.avatar}'),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Username: ${widget.userProfileData.username}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Email: ${widget.userProfileData.email}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isAdmin ? Icons.verified : Icons.person_pin,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(width: 5),
                    Text(
                      isAdmin ? 'Admin' : 'User',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Comments Allowed',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.comment_rounded,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Comments Count: ${widget.userProfileData.commentsCount}',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Favorite Books',
                  style: TextStyle(fontSize: 28),
                ),
                // FutureBuilder(
                // future: favoriteBooks,
                // builder: (context, snapshot) {
                // if (snapshot.connectionState ==
                //   ConnectionState.waiting) {
                //  return CircularProgressIndicator();
                //} else if (snapshot.hasError) {
                //  return Text('Error: ${snapshot.error}');
                //  } else if (snapshot.data != null) {
                // return Row(
                // children: snapshot.data!.map((book) {
                //  return BookCard(book: book);
                //  }).toList(),
                //  );
                // } else {
                //   return Text('No Data');
                // }
                //},
                //),

                Container(
                  height: 350,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.userProfileData.favoriteBooks!.length,
                    itemBuilder: (context, index) {
                      List<dynamic> favoriteBooks =
                          widget.userProfileData.favoriteBooks!;
                      if (favoriteBooks.isNotEmpty) {
                        Map<String, dynamic> bookData =
                            widget.userProfileData.favoriteBooks![index];
                        Book book = Book(
                          id: bookData['_id'],
                          title: bookData['title'],
                          author: bookData['author'],
                          genre: bookData['genre'],
                          year: bookData['year'],
                          description: bookData['description'],
                          cover: bookData['cover'],
                          isbn: bookData['isbn'],
                          pagesCount: bookData['pagesCount'],
                          price: bookData['price'],
                          creationDate:
                              DateTime.parse(bookData['creationDate']),
                        );
                        return GestureDetector(
                          child: Container(
                            width: 250,
                            height: 350,
                            child: Card(
                              elevation: 4, // Adjust the shadow of the card
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Set border radius
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                                NetworkImage(book.cover ?? ''),
                                            fit: BoxFit.fill)),
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
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 4.0),
                                            Text(
                                              book.author.toString(),
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.grey),
                                            ),
                                            SizedBox(height: 4.0),
                                            ElevatedButton(
                                                style: ButtonStyle(),
                                                onPressed: () => {
                                                      if (widget.authNotifier
                                                              .token ==
                                                          '')
                                                        {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      'You have to login')))
                                                        }
                                                      else
                                                        {
                                                          checkAndAddBookToCart(
                                                              widget
                                                                  .authNotifier,
                                                              book.id!)
                                                        }
                                                    },
                                                child: Text('Add to cart'))
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            print(book.id);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookDetails(
                                          bookID: book.id.toString(),
                                          authNotifier: widget.authNotifier,
                                        )));
                          },
                        );
                      } else {
                        return Icon(Icons.not_interested_sharp);
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
        ));
  }

  Future<void> checkAndAddBookToCart(
      AuthorizationProvider authorizationProvider, String bookId) async {
    // Get the current cart
    ServerResponse cartResponse =
        await cartService.getCart(authorizationProvider.token);

    // Check if the book is already in the cart
    bool isBookInCart = false;
    if (cartResponse.data != null && cartResponse.data['books'] is List) {
      List<dynamic> cartItems = cartResponse.data['books'];
      isBookInCart = cartItems.any((item) => item['_id'] == bookId);
    }

    // Add the book to the cart if it's not already present
    if (!isBookInCart) {
      ServerResponse addToCartResponse =
          await cartService.addBookToCart(authorizationProvider.token, bookId);
      print('Add to cart response ${addToCartResponse.message}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('You added book to cart')));
      authorizationProvider.cartSize++;
    } else {
      print('The book is already in the cart.');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The book is already in the cart')));
    }
  }
}
