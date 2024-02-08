import 'dart:async';
import 'package:book_store_flutter/models/user.model.dart';
import 'package:book_store_flutter/screens/login.dart';
import 'package:book_store_flutter/screens/profile.dart';
import 'package:book_store_flutter/screens/register.dart';
import 'package:book_store_flutter/widgets/snackBar.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/authentication.provider.dart';
import '../providers/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final Future<SharedPreferences> sharedPreferences =
      SharedPreferences.getInstance();

  Future<User>? userProfile;

  //late Future<String> token;

  @override
  Widget build(BuildContext context) {
    final screenProvider = Provider.of<ScreenProvider>(context, listen: false);

    return Drawer(
        surfaceTintColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          child: ListView(children: [
            Consumer<AuthorizationProvider>(
              builder: (context, authNotifier, child) {
                if (authNotifier.authenticated) {
                  String username = authNotifier.username;
                  userProfile = authNotifier.updateProfile(username);
                  return FutureBuilder<User>(
                    future: userProfile,
                    builder: (context, AsyncSnapshot<User> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LinearProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        User user = snapshot.data!;
                        print('FAVORITE BOOKS: ${user.favoriteBooks}');
                        return UserAccountsDrawerHeader(
                          accountName: Text('${user.username}'),
                          accountEmail: Text('${user.email}'),
                          currentAccountPicture: CircleAvatar(
                              backgroundImage: NetworkImage('${user.avatar}')),
                          onDetailsPressed: () async {
                            final bool? isRemoved = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Profile(
                                    userProfileData: user,
                                    authNotifier: authNotifier,
                                  ),
                                ));

                            if (isRemoved != null && isRemoved) {
                              setState(() {
                                authNotifier.updateProfile(username);
                              });
                            }
                          },
                        );
                      }
                    },
                  );
                } else {
                  return const ListTile(
                      title: Icon(Icons.no_accounts, size: 80));
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
            Consumer<AuthorizationProvider>(
              builder: (context, authNotifier, child) {
                if (authNotifier.authenticated == false) {
                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.app_registration_rounded),
                        title: const Text('Register'),
                        onTap: () {
                          // Handle navigation to Settings screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Register(authNotifier: authNotifier),
                              ));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.login_rounded),
                        title: const Text('Login'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Login(authNotifier: authNotifier),
                            ),
                          );
                        },
                      )
                    ],
                  );
                } else {
                  return ListTile(
                    leading: const Icon(Icons.login_rounded),
                    title: const Text('Logout'),
                    onTap: () {
                      authNotifier.signOut();
                      screenProvider.selectFirstScreen();
                      Navigator.pop(context);
                      SnackBarNotification.show(
                          context, 'You successfully logged out', Colors.green);
                    },
                  );
                }
              },
            ),
          ]),
        ));
  }
}
