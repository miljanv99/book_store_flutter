import 'package:book_store_flutter/models/book.model.dart';
import 'package:book_store_flutter/providers/screenProvider.dart';
import 'package:book_store_flutter/widgets/book/bookDetails.dart';
import 'package:book_store_flutter/services/book.service.dart';
import 'package:book_store_flutter/widgets/comment/commetSection.widget.dart';
import 'package:flutter/material.dart';

import '../providers/authentication.provider.dart';
import '../widgets/snackBar.widget.dart';

class BookDetailsAndComments extends StatefulWidget {
  final Book book;
  final AuthorizationProvider authNotifier;
  final BookDetailsScreensProvider bookDetailsScreensProvider;
  bool isFavorite;
  BookDetailsAndComments({
    Key? key,
    required this.book,
    required this.authNotifier,
    required this.isFavorite,
    required this.bookDetailsScreensProvider,
  }) : super(key: key);

  @override
  _BookDetailsAndCommentsState createState() => _BookDetailsAndCommentsState();
}

class _BookDetailsAndCommentsState extends State<BookDetailsAndComments> {
  @override
  Widget build(BuildContext context) {
    BookService bookService = BookService();

    List<Widget> bookScreens = [
      BookDetails(
        bookID: widget.book.id!,
        authNotifier: widget.authNotifier,
        isFavorite: widget.isFavorite,
      ),
      CommentSection(
        book: widget.book,
        authorizationProvider: widget.authNotifier,
      ),
    ];
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
                      widget.authNotifier.token, widget.book.id!);
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
            future: bookService.getSingleBook(widget.book.id!),
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
        body: bookScreens[widget.bookDetailsScreensProvider.selectedBookScreen],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => setState(() {
            widget.bookDetailsScreensProvider.displayBookScreen(value);
          }),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Details',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.comment),
              label: 'Comments',
            ),
          ],
          currentIndex: widget.bookDetailsScreensProvider.selectedBookScreen,
        ),
      ),
      onWillPop: () async {
        widget.isFavorite == false
            ? Navigator.pop(context, true)
            : Navigator.pop(context, false);
        widget.bookDetailsScreensProvider.selectedBookScreen = 0;
        return true;
      },
    );
  }
}
