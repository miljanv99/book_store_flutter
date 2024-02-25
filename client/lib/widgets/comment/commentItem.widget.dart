import 'package:book_store_flutter/models/comment.model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentItemWidget extends StatefulWidget {
  final Comment comment;
  const CommentItemWidget({Key? key, required this.comment}) : super(key: key);

  @override
  _CommentItemWidgetState createState() => _CommentItemWidgetState();
}

class _CommentItemWidgetState extends State<CommentItemWidget> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        duration: const Duration(seconds: 1),
        tween: Tween<double>(begin: 0, end: 1),
        curve: Curves.easeInOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: const BorderSide(
              color: Colors.blueAccent,
              width: 2.0,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: const Color.fromARGB(255, 219, 233, 255),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  textColor: Colors.black87,
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
                      backgroundImage:
                          NetworkImage('${widget.comment.user!.avatar}'),
                    ),
                  ),
                  title: Text(
                    '${widget.comment.user!.username}',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat('dd-MM-yyyy HH:mm:ss')
                        .format(widget.comment.creationDate!),
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
                ListBody(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(
                        '${widget.comment.content}',
                        style: const TextStyle(color: Colors.black87),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
