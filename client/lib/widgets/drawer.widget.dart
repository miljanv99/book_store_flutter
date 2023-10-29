import 'package:book_store_flutter/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final Future<SharedPreferences> sharedPreferences =
      SharedPreferences.getInstance();

  late Future<String> token;

  @override
  void initState() {
    super.initState();
    token = sharedPreferences.then((SharedPreferences sp) {
      return sp.getString('token')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("John Doe"),
            accountEmail: Text("john.doe@example.com"),
            currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://e7.pngegg.com/pngimages/348/800/png-clipart-man-wearing-blue-shirt-illustration-computer-icons-avatar-user-login-avatar-blue-child.png')),
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
          FutureBuilder(
            future: token,
            builder:
                (BuildContext context, AsyncSnapshot<String> snapshotToken) {
              if (!snapshotToken.hasData) {
                return ListTile(
                  leading: const Icon(Icons.login_rounded),
                  title: const Text('Login'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ));
                  },
                );
              } else {
                return ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Logout'),
                  onTap: () {
                    deleteToken();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:  Text("You've successfully logged out.")
                      )
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

    void deleteToken() {
    sharedPreferences.then((SharedPreferences sp) =>
        sp.remove('token').then((bool isOK) {
          if (isOK) {
            print('Token is successfuly removed');
          } else {
            print('Token is not successfuly removed');
          }
        }));
  }
}