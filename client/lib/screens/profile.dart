import 'package:book_store_flutter/models/serverResponse.model.dart';
import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:book_store_flutter/widgets/favoriteBooks.widget.dart';
import 'package:book_store_flutter/widgets/snackBar.widget.dart';
import 'package:flutter/material.dart';
import '../models/user.model.dart';

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
  UserService userService = UserService();

  final formKey = GlobalKey<FormState>();

  final TextEditingController avatarUrlCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print("PROFILE BOOKS: ${widget.userProfileData.favoriteBooks}");
    bool isAdmin = widget.userProfileData.isAdmin!;
    favoriteBooks = widget.userProfileData.favoriteBooks;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.blueAccent,
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 26),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TapRegion(
                  child: Container(
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
                  onTapInside: (event) {
                    showModalBottomSheet<void>(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                            child: AnimatedPadding(
                          padding: MediaQuery.of(context).viewInsets,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.ease,
                          child: SizedBox(
                            height: 200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text("Insert Avatar's URL"),
                                  Form(
                                      key: formKey,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Avatar is required';
                                            }
                                            return null;
                                          },
                                          controller: avatarUrlCtrl,
                                          decoration: const InputDecoration(
                                              labelText: 'Avatar: URL'),
                                        ),
                                      )),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    child: const Text('Change Profile Picture'),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        print(
                                            "userID: ${widget.authNotifier.userId}");
                                        print(
                                            "user token: ${widget.authNotifier.token}");
                                        Map<String, dynamic> formInputs = {
                                          'id': widget.authNotifier.userId,
                                          'avatar': avatarUrlCtrl.text
                                        };

                                        Future<ServerResponse> serverResponse =
                                            userService.changeAvatar(
                                                widget.authNotifier.token,
                                                formInputs);

                                        serverResponse.then((response) {
                                          if (response.errors == null) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            SnackBarNotification.show(context,
                                                response.message, Colors.green);
                                          } else {
                                            Navigator.pop(context);
                                            SnackBarNotification.show(context,
                                                response.errors!['avatar'], Colors.red);
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Username: ${widget.userProfileData.username}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Email: ${widget.userProfileData.email}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isAdmin ? Icons.verified : Icons.person_pin,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isAdmin ? 'Admin' : 'User',
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.comment_rounded,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Comments Count: ${widget.userProfileData.commentsCount}',
                      style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Favorite Books',
                  style: TextStyle(fontSize: 28),
                ),
                FavoriteBooksWidget(
                    userProfileData: widget.userProfileData,
                    authNotifier: widget.authNotifier)
              ],
            ),
          )),
        ));
  }
}
