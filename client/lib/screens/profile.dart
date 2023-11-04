import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/user.model.dart';

class Profile extends StatefulWidget {

  final User userProfileData;

  const Profile({ Key? key, required this.userProfileData }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    
    bool isAdmin = widget.userProfileData.isAdmin!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 4.0,
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('${widget.userProfileData.avatar}'),
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
                  isAdmin ? Icons.verified : Icons.not_interested_rounded,
                  color: Colors.blueAccent,
                ),
                SizedBox(width: 5),
                Text(
                  'Admin',
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
            Text(
              'Comments Count:',
              style: TextStyle(fontSize: 16),
            ),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}