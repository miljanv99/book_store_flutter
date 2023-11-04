import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/providers/provider.dart';
import 'package:book_store_flutter/screens/cart.dart';
import 'package:book_store_flutter/screens/home.dart';
import 'package:book_store_flutter/screens/store.dart';
import 'package:book_store_flutter/widgets/drawer.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ScreenProvider()),
            ChangeNotifierProvider(
                create: ((context) => AuthorizationProvider())),
          ],
          child: const MyHomePage(title: 'Book Store'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> screens = const [Home(), Store()];
  @override
  Widget build(BuildContext context) {
    return Consumer2<ScreenProvider, AuthorizationProvider>(
        builder: (context, screenProvider, authNotifier, child) {
      print('IN MAIN: ${authNotifier.authenticated}');
      print('IN TOKEN: ${authNotifier.token}');
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Cart(),
                    ));
              },
              icon: const Icon(Icons.shopping_cart_rounded),
              iconSize: 28,
            )
          ],
        ),
        drawer: DrawerWidget(authNotifier: authNotifier),
        body: screens[screenProvider.selectedScreen],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => screenProvider.displayScreen(value),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Store')
          ],
          currentIndex: screenProvider.selectedScreen,
        ),
      );
    });
  }
}
