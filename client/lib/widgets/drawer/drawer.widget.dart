import 'dart:async';
import 'package:book_store_flutter/models/user.model.dart';
import 'package:book_store_flutter/providers/screenProvider.dart';
import 'package:book_store_flutter/widgets/drawer/drawerItems.widget.dart';
import 'package:flutter/material.dart';
import '../../providers/authentication.provider.dart';

class DrawerWidget extends StatefulWidget {
  final AuthorizationProvider authorizationProvider;
  final ThemeSettings themeSettings;
  const DrawerWidget({Key? key, required this.authorizationProvider, required this.themeSettings})
      : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Future<User>? userProfile;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        const DrawerHeader(
          margin: null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Book Store', // Updated title
                style: TextStyle(
                  fontSize: 32, // Increased font size
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico', // Changed font to Pacifico
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Embark on a Literary Journey', // Updated subtitle
                style: TextStyle(
                  fontSize: 18, // Increased font size
                  fontFamily: 'OpenSans', // Changed font to OpenSans
                ),
              ),
            ],
          ),
        ),
        DrawerItemsWidget(
            authorizationProvider: widget.authorizationProvider,
            themeSettings: widget.themeSettings,
            userProfile: userProfile),
      ]),
    );
  }
}
