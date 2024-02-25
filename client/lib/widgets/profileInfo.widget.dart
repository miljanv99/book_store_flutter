import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:flutter/material.dart';

import '../models/user.model.dart';
import '../providers/screenProvider.dart';
import 'avatar.widget.dart';
import 'book/favoriteBooks.widget.dart';

class ProfileInfoWidget extends StatefulWidget {
  final AuthorizationProvider authNotifier;
  final BookDetailsScreensProvider bookDetailsScreensProvider;
  final User userProfileData;
  const ProfileInfoWidget(
      {Key? key,
      required this.authNotifier,
      required this.userProfileData,
      required this.bookDetailsScreensProvider})
      : super(key: key);

  @override
  _ProfileInfoWidgetState createState() => _ProfileInfoWidgetState();
}

class _ProfileInfoWidgetState extends State<ProfileInfoWidget> {
  final TextEditingController avatarUrlCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.userProfileData.isAdmin!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AvatarWidget(
            authNotifier: widget.authNotifier,
            userProfileData: widget.userProfileData,
            avatarCtrl: avatarUrlCtrl),
        const SizedBox(height: 20),
        Text(
          'Username: ${widget.userProfileData.username}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            authNotifier: widget.authNotifier,
            bookDetailsScreensProvider: widget.bookDetailsScreensProvider)
      ],
    );
  }
}
