import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:book_store_flutter/widgets/avatar.widget.dart';
import 'package:book_store_flutter/widgets/favoriteBooks.widget.dart';
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
                AvatarWidget(
                    authNotifier: widget.authNotifier,
                    userProfileData: widget.userProfileData,
                    avatarCtrl: avatarUrlCtrl),
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
