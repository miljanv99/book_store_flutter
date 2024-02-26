import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/providers/screenProvider.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:book_store_flutter/widgets/user/profileInfo.widget.dart';
import 'package:flutter/material.dart';
import '../models/user.model.dart';

class Profile extends StatefulWidget {
  final User userProfileData;
  final AuthorizationProvider authNotifier;
  final BookDetailsScreensProvider bookDetailsScreensProvider;
  const Profile(
      {Key? key,
      required this.userProfileData,
      required this.authNotifier,
      required this.bookDetailsScreensProvider})
      : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<dynamic>? favoriteBooks;
  CartService cartService = CartService();
  UserService userService = UserService();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    print("PROFILE BOOKS: ${widget.userProfileData.favoriteBooks}");
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
            child: ProfileInfoWidget(
                authNotifier: widget.authNotifier,
                userProfileData: widget.userProfileData,
                bookDetailsScreensProvider: widget.bookDetailsScreensProvider),
          )),
        ));
  }
}
