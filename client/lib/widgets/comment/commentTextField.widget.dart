import 'package:book_store_flutter/models/book.model.dart';
import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/widgets/snackBar.widget.dart';
import 'package:flutter/material.dart';
import '../../models/serverResponse.model.dart';
import '../../services/comment.service.dart';

class CommentTextFieldWidget extends StatefulWidget {
  final AuthorizationProvider authorizationProvider;
  final Book book;
  final Function refreshComments;
  const CommentTextFieldWidget(
      {Key? key,
      required this.authorizationProvider,
      required this.book,
      required this.refreshComments})
      : super(key: key);

  @override
  _CommentTextFieldWidgetState createState() => _CommentTextFieldWidgetState();
}

class _CommentTextFieldWidgetState extends State<CommentTextFieldWidget> {
  CommentService commentService = CommentService();
  TextEditingController commentController = TextEditingController();
  ValueNotifier<String> commentValueNotifier = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 100),
      curve: Curves.ease,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  NetworkImage(widget.authorizationProvider.userAvatar),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  print('ON CHANGE: ${commentValueNotifier.value.length}');
                  setState(() {
                    commentValueNotifier.value = value;
                  });
                },
                controller: commentController,
                decoration: const InputDecoration(
                  hintText: 'Add a comment...',
                ),
              ),
            ),
            IconButton(
              onPressed: commentValueNotifier.value.length >= 3
                  ? () {
                      Map<String, dynamic> commentContent = {
                        "content": commentValueNotifier.value
                      };
                      Future<ServerResponse> serverResponse =
                          commentService.addComment(
                              widget.authorizationProvider.token,
                              widget.book.id!,
                              commentContent);
                      serverResponse.then((response) {
                        response.data != null
                            ? (
                                commentController.text = '',
                                commentValueNotifier.value = '',
                                widget.refreshComments(),
                              )
                            : (response.errors!['content'] ==
                                    'Maximum number of characters are 200.'
                                ? SnackBarNotification.show(
                                    context, '${response.errors!['content']}', Colors.red)
                                : null);
                      });
                    }
                  : null,
              icon: const Icon(Icons.send_rounded),
              color: Colors.blueAccent,
              iconSize: 30,
            )
          ],
        ),
      ),
    );
  }
}
