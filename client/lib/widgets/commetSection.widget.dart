import 'package:book_store_flutter/models/book.model.dart';
import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/services/book.service.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/services/comment.service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/comment.model.dart';
import '../models/serverResponse.model.dart';
import '../utils/screenWidth.dart';

class CommentSection extends StatefulWidget {
  final Book book;
  final AuthorizationProvider authorizationProvider;
  const CommentSection(
      {Key? key, required this.book, required this.authorizationProvider})
      : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  CartService cartService = CartService();
  BookService bookService = BookService();
  TextEditingController commentController = TextEditingController();
  CommentService commentService = CommentService();

  @override
  Widget build(BuildContext context) {
    double maxWidth = calculateMaxWidth(context);
    return Center(
      child: SizedBox(
        width: maxWidth,
        child: Column(
          children: [
            const SizedBox(height: 20),
            FutureBuilder(
              future: commentService.getComments(widget.book.id!, 0),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  ServerResponse response = snapshot.data!;
                  List commentList = (response.data as List)
                      .map((commentJson) => Comment.fromJson(commentJson))
                      .toList();
                  if (commentList.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: commentList.length,
                        itemBuilder: (context, index) {
                          Comment comment = commentList[index];
                          return Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ListTile(
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                          '${comment.user!.avatar}'),
                                    ),
                                  ),
                                  title: Text('${comment.user!.username}'),
                                  subtitle: Text(
                                      DateFormat('dd-MM-yyyy HH:mm:ss')
                                          .format(comment.creationDate!)),
                                ),
                                ListBody(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, bottom: 10),
                                      child: Text('${comment.content}'),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Expanded(
                        child: Center(
                      child: Icon(
                        Icons.comments_disabled_rounded,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ));
                  }
                } else {
                  return const Text('No Comments');
                }
              },
            ),
            const SizedBox(height: 10),
            if (widget.authorizationProvider.authenticated)
              AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                curve: Curves.ease,
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  margin:
                      const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            widget.authorizationProvider.userAvatar),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: const InputDecoration(
                            hintText: 'Add a comment...',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.send_rounded),
                        color: Colors.blueAccent,
                        iconSize: 30,
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
