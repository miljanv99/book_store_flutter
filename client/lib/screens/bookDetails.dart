import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/services/book.service.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:book_store_flutter/utils/globalMethods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/book.model.dart';
import '../widgets/snackBar.widget.dart';
import '../utils/screenWidth.dart';

class BookDetails extends StatefulWidget {
  final String bookID;
  //final String token;
  final AuthorizationProvider authNotifier;
  var isFavorite;
  BookDetails(
      {Key? key,
      required this.bookID,
      required this.authNotifier,
      required this.isFavorite})
      : super(key: key);

  BookService bookService = BookService();
  CartService cartService = CartService();
  GlobalMethods globalMethods = GlobalMethods();

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  BookService bookService = BookService();
  UserService userService = UserService();
  @override
  Widget build(BuildContext context) {
    double maxWidth = calculateMaxWidth(context);

    print('BEFORE: ${widget.isFavorite}');

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            titleTextStyle: const TextStyle(fontSize: 15, color: Colors.white),
            backgroundColor: Colors.blueAccent,
            centerTitle: true,
            actions: [
              if (widget.authNotifier.authenticated)
                IconButton(
                  onPressed: () {
                    bookService.addOrRemoveFavouriteBook(
                        widget.authNotifier.token, widget.bookID);
                    setState(() {
                      widget.isFavorite = !widget.isFavorite;
                    });
                    if (widget.isFavorite) {
                      SnackBarNotification.show(context,
                          'The book is added to favorites', Colors.green);
                    } else {
                      SnackBarNotification.show(context,
                          'The book is removed from favorites', Colors.green);
                    }
                  },
                  icon: Icon(
                    widget.isFavorite == true
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 35,
                  ),
                  color: Colors.redAccent,
                ),
            ],
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  if (widget.authNotifier.token == '') {
                                    SnackBarNotification.show(context,
                                        'You have to login!', Colors.red);
                                  } else {
                                    widget.globalMethods.checkAndAddBookToCart(
                                        widget.authNotifier, book.id!, context, widget.cartService);
                                  }
                                },
                                child: Text('Add To Cart'),
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
        ),
        onWillPop: () async{
          if (widget.isFavorite == false) {
            Navigator.pop(context, true);
          } else {
            Navigator.pop(context, false);
          }
          return true;
        });
  }

}
