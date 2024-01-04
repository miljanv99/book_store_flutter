import 'package:flutter/material.dart';
import '../models/book.model.dart';
import '../models/user.model.dart';
import '../providers/authentication.provider.dart';
import '../screens/bookDetails.dart';

class FavoriteBooksWidget extends StatefulWidget {
  final User userProfileData;
  final AuthorizationProvider authNotifier;
  const FavoriteBooksWidget(
      {Key? key, required this.userProfileData, required this.authNotifier})
      : super(key: key);

  @override
  _FavoriteBooksWidgetState createState() => _FavoriteBooksWidgetState();
}

class _FavoriteBooksWidgetState extends State<FavoriteBooksWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.userProfileData.favoriteBooks!.length > 0) {
      return Center(
        child: Container(
          height: 350,
          margin: EdgeInsets.all(5),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.userProfileData.favoriteBooks?.length,
            itemBuilder: (context, index) {
              List<dynamic>? favoriteBooks =
                  widget.userProfileData.favoriteBooks;
              if (favoriteBooks != null) {
                Map<String, dynamic> bookData =
                    widget.userProfileData.favoriteBooks![index];
                Book book = Book(
                  id: bookData['_id'],
                  title: bookData['title'],
                  author: bookData['author'],
                  genre: bookData['genre'],
                  year: bookData['year'],
                  cover: bookData['cover'],
                  isbn: bookData['isbn'],
                  pagesCount: bookData['pagesCount'],
                  price: bookData['price'].toDouble(),
                  creationDate: DateTime.parse(bookData['creationDate']),
                );

                return GestureDetector(
                  child: Container(
                    width: 250,
                    height: 350,
                    margin: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(book.cover ?? ''),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12.0)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Column(
                                children: [
                                  Text(
                                    book.title.toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Author: ${book.author.toString()}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Genre: ${book.genre.toString()}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Year: ${book.year.toString()}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () async {
                    print(book.id);
                    final bool isRemoved = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetails(
                          bookID: book.id.toString(),
                          authNotifier: widget.authNotifier,
                          isFavorite: true,
                        ),
                      ),
                    );
                    if (isRemoved) {
                      Navigator.pop(context, true);
                    }
                  },
                );
              }
            },
          ),
        ),
      );
    } else {
      return Container(
          margin: EdgeInsets.only(top: 10),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.not_interested_rounded,
                  color: Colors.blueAccent,
                ),
                SizedBox(width: 5),
                Text(
                  'No Favorite books',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ));
    }
  }
}
