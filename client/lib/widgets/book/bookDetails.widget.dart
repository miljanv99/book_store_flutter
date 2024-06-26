import 'package:book_store_flutter/models/book.model.dart';
import 'package:book_store_flutter/models/serverResponse.model.dart';
import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/services/book.service.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/utils/globalMethods.dart';
import 'package:book_store_flutter/utils/screenWidth.dart';
import 'package:book_store_flutter/widgets/snackBar.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../providers/screenProvider.dart';
import '../../services/comment.service.dart';
import 'package:provider/provider.dart';

class BookDetailsWidget extends StatefulWidget {
  final AuthorizationProvider authNotifier;
  final Book book;
  const BookDetailsWidget(
      {Key? key, required this.authNotifier, required this.book})
      : super(key: key);

  @override
  _BookDetailsWidgetState createState() => _BookDetailsWidgetState();
}

class _BookDetailsWidgetState extends State<BookDetailsWidget> {
  GlobalMethods globalMethods = GlobalMethods();
  CartService cartService = CartService();
  BookService bookService = BookService();
  late TextEditingController commentController;
  late CommentService commentService;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    commentService = CommentService();
  }

  @override
  Widget build(BuildContext context) {
    bool aleadyRated =
        widget.book.ratedBy!.contains(widget.authNotifier.userId);
    double maxWidth = calculateMaxWidth(context);
    double? currentRating = widget.book.currentRating;
    final settings = Provider.of<ThemeSettings>(context);
    final textColor = settings.currentTheme == ThemeData.light()
        ? Colors.black
        : Colors.white;
    print("first already rated: ${aleadyRated}");
    return SingleChildScrollView(
      child: Container(
        width: maxWidth,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: settings.currentTheme == ThemeData.light()
              ? Colors.white
              : Colors.black38,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
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
                  image: NetworkImage(widget.book.cover ?? ''),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.book.title ?? 'Title not available',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Author: ${widget.book.author ?? 'Author not available'}',
              style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.blueAccent),
            ),
            const SizedBox(height: 10),
            Text(
              'Genre: ${widget.book.genre ?? 'Genre not available'}',
              style: const TextStyle(fontSize: 18, color: Colors.blueAccent),
            ),
            const SizedBox(height: 10),
            Text(
              'Year: ${widget.book.year ?? 'Year not available'}',
              style: const TextStyle(fontSize: 18, color: Colors.blueAccent),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RatingBar.builder(
                  initialRating: currentRating!,
                  updateOnDrag: false,
                  minRating: 1,
                  direction: Axis.horizontal,
                  unratedColor: Colors.grey,
                  itemCount: 5,
                  itemSize: 40.0,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  ignoreGestures:
                      !widget.authNotifier.authenticated || aleadyRated,
                  onRatingUpdate: (rating) async {
                    int ratingCustom = rating.toInt();

                    Map<String, dynamic> ratingPayload = {
                      "rating": ratingCustom
                    };
                    setState(() {
                      aleadyRated = true;
                    });
                    Future<ServerResponse> rateBookResponse =
                        bookService.rateTheBook(widget.authNotifier.token,
                            widget.book.id!, ratingPayload);

                    rateBookResponse.then((response) {
                      if (response.message ==
                          'You rated the book successfully.') {
                        setState(() {
                          widget.book.ratedCount = response.data['ratedCount'];
                        });

                        SnackBarNotification.show(
                            context, response.message, Colors.green);
                        print('GESTURE: ${aleadyRated}');
                      } else {
                        SnackBarNotification.show(
                            context, response.message, Colors.red);
                        print('GESTURE: ${aleadyRated}');
                      }
                    });
                  },
                ),
                const SizedBox(width: 5),
                if (widget.authNotifier.authenticated && aleadyRated == true)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.greenAccent,
                    size: 35,
                  ),
                const SizedBox(width: 5),
                Icon(
                  Icons.supervised_user_circle_rounded,
                  size: 35,
                  color: textColor,
                ),
                const SizedBox(width: 5),
                Text(
                  '${widget.book.ratedCount}',
                  style: TextStyle(fontSize: 25, color: textColor),
                ),
              ],
            ),
            Text(
              'Description:',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor),
            ),
            const SizedBox(height: 10),
            Text(
              widget.book.description ?? 'Description not available',
              style: TextStyle(fontSize: 16, color: textColor),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pages: ${widget.book.pagesCount ?? 'N/A'}',
                  style:
                      const TextStyle(fontSize: 18, color: Colors.blueAccent),
                ),
                Text(
                  'Price: \$${widget.book.price ?? 'N/A'}',
                  style:
                      const TextStyle(fontSize: 18, color: Colors.blueAccent),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget.authNotifier.token == '') {
                  SnackBarNotification.show(
                      context, 'You have to login!', Colors.red);
                } else {
                  globalMethods.checkAndAddBookToCart(widget.authNotifier,
                      widget.book.id!, context, cartService);
                }
              },
              child: const Text('Add To Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
