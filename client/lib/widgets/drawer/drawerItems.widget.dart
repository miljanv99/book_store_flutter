import 'package:book_store_flutter/models/user.model.dart';
import 'package:book_store_flutter/widgets/snackBar.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/authentication.provider.dart';
import '../../providers/screenProvider.dart';
import '../../screens/cart.dart';
import '../../screens/login.dart';
import '../../screens/profile.dart';
import '../../screens/register.dart';
import '../user/avatar.widget.dart';
import '../cart/cartBadgeCounter.widget.dart';

class DrawerItemsWidget extends StatefulWidget {
  final AuthorizationProvider authorizationProvider;
  Future<User>? userProfile;
  DrawerItemsWidget(
      {Key? key, required this.authorizationProvider, this.userProfile})
      : super(key: key);

  @override
  _DrawerItemsWidgetState createState() => _DrawerItemsWidgetState();
}

class _DrawerItemsWidgetState extends State<DrawerItemsWidget> {
  @override
  Widget build(BuildContext context) {
    final screenProvider = Provider.of<ScreenProvider>(context, listen: false);
    return Consumer2<AuthorizationProvider, BookDetailsScreensProvider>(
      builder: (context, authNotifier, bookDetailsProvider, child) {
        if (authNotifier.authenticated) {
          String username = authNotifier.username;
          widget.userProfile =
              widget.authorizationProvider.updateProfile(username);
          return Column(
            children: [
              FutureBuilder<User>(
                future: widget.userProfile,
                builder: (context, AsyncSnapshot<User> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LinearProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    User user = snapshot.data!;
                    print('FAVORITE BOOKS: ${user.favoriteBooks}');
                    return UserAccountsDrawerHeader(
                      margin: null,
                      arrowColor: Colors.black,
                      accountName: Text('${user.username}',
                          style: const TextStyle(color: Colors.black)),
                      accountEmail: Text('${user.email}',
                          style: const TextStyle(color: Colors.black)),
                      currentAccountPicture: AvatarWidget(userProfileData: user),
                      decoration: const BoxDecoration(color: null),
                      onDetailsPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(
                              userProfileData: user,
                              authNotifier: authNotifier,
                              bookDetailsScreensProvider: bookDetailsProvider,
                            ),
                          ),
                        );

                        setState(() {
                          authNotifier.updateProfile(username);
                        });
                      },
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_basket),
                title: const Text('Cart'),
                trailing: CartBadgeCounterWidget(
                    authorizationProvider: widget.authorizationProvider),
                onTap: () {
                  // Handle navigation to Cart screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(
                        authorizationProvider: widget.authorizationProvider,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  authNotifier.signOut();
                  screenProvider.selectFirstScreen();
                  Navigator.pop(context);
                  SnackBarNotification.show(
                      context, 'You successfully logged out', Colors.green);
                },
              ),
            ],
          );
        } else {
          return Column(
            children: [
              const ListTile(title: Icon(Icons.no_accounts, size: 80)),
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
                    ),
                  );
                },
              ),
              ListTile(
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
              ),
            ],
          );
        }
      },
    );
  }
}
