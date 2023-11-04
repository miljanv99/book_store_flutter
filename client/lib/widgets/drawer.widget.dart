import 'dart:async';
import 'package:book_store_flutter/models/user.model.dart';
import 'package:book_store_flutter/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/authentication.provider.dart';

class DrawerWidget extends StatefulWidget {

  final AuthorizationProvider authNotifier;

  const DrawerWidget({Key? key, required this.authNotifier}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final Future<SharedPreferences> sharedPreferences =
      SharedPreferences.getInstance();

  late final Future<User> userProfile;
  //late Future<String> token;

  @override
  Widget build(BuildContext context) {

    return Drawer(
        child: Container(
      padding: EdgeInsets.only(top: 20),
      child: ListView(children: [      
        Consumer<AuthorizationProvider>(
          builder: (context, authNotifier, child) {
            if(authNotifier.authenticated){
              String username = authNotifier.username;
              userProfile = authNotifier.updateProfile(username);
               return FutureBuilder<User>(
                future: userProfile,
                builder: (BuildContext context, AsyncSnapshot<User>snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if(snapshot.hasError){
                    return Text('Error: ${snapshot.error}');
                  } else {
                    User user = snapshot.data!;
                    return  UserAccountsDrawerHeader(
                          accountName: Text('${user.username}'),
                          accountEmail: Text('${user.email}'),
                          currentAccountPicture: CircleAvatar(
                          backgroundImage: NetworkImage('${user.avatar}')
                      ),
                    );
                  }
                },
              );
            }else {
              return ListTile(
                title: Icon(Icons.no_accounts, size: 80)
              );
            }
          },
        ),
        
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            // Handle navigation to Home screen
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.shopping_basket),
          title: const Text('Cart'),
          onTap: () {
            // Handle navigation to Cart screen
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.category),
          title: const Text('Categories'),
          onTap: () {
            // Handle navigation to Categories screen
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.favorite),
          title: const Text('Favorites'),
          onTap: () {
            // Handle navigation to Favorites screen
            Navigator.pop(context);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {
            // Handle navigation to Settings screen
            Navigator.pop(context);
          },
        ),
        Consumer<AuthorizationProvider>(
          builder: (context, authNotifier, child) {
            print('IN CONSUME: ${authNotifier.authenticated}');
            if (authNotifier.authenticated == false) {
              return ListTile(
                leading: const Icon(Icons.login_rounded),
                title: const Text('Login'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(authNotifier: authNotifier),
                    ),
                  );
                },
              );
            } else {
              return ListTile(
                leading: const Icon(Icons.login_rounded),
                title: const Text('Logout'),
                onTap: () {
                  authNotifier.signOut();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('You successfully logged out')));
                },
              );
            }
          },
        )
      ]),
    ));
  }
}
