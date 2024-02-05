import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/widgets/favoriteBooks.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  @override
  Widget build(BuildContext context) {
    print("PROFILE BOOKS: ${widget.userProfileData.favoriteBooks}");
    bool isAdmin = widget.userProfileData.isAdmin!;
    favoriteBooks = widget.userProfileData.favoriteBooks;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.blueAccent,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 26),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
              child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
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
                SizedBox(height: 20),
                Text(
                  'Username: ${widget.userProfileData.username}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Email: ${widget.userProfileData.email}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isAdmin ? Icons.verified : Icons.person_pin,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(width: 5),
                    Text(
                      isAdmin ? 'Admin' : 'User',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
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
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.comment_rounded,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Comments Count: ${widget.userProfileData.commentsCount}',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Favorite Books',
                  style: TextStyle(fontSize: 28),
                ),
                FavoriteBooksWidget(userProfileData: widget.userProfileData, authNotifier: widget.authNotifier)
              ],
            ),
          )),
        ));
  }
}
