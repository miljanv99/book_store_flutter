import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/providers/screenProvider.dart';
import 'package:book_store_flutter/screens/home.dart';
import 'package:book_store_flutter/screens/purchaseHistory.dart';
import 'package:book_store_flutter/screens/store.dart';
import 'package:book_store_flutter/widgets/cart/cart.widget.dart';
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
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ScreenProvider()),
            ChangeNotifierProvider(
                create: ((context) => AuthorizationProvider())),
             ChangeNotifierProvider(create: ((context) => BookDetailsScreensProvider())),
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
  List<Widget> screens = [const Home(), const Store(), const PurchaseHistory()];
  @override
  Widget build(BuildContext context) {
    return Consumer2<ScreenProvider, AuthorizationProvider>(
        builder: (context, screenProvider, authNotifier, child) {
      print('IN MAIN: ${authNotifier.authenticated}');
      print('IN TOKEN: ${authNotifier.token}');
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: Text(widget.title,
                style: const TextStyle(color: Colors.white, fontSize: 24)),
            centerTitle: true,
            actions: [
              if (authNotifier.authenticated)
                const CartWidget(),
            ],
          ),
          drawer: const DrawerWidget(),
          body: screens[screenProvider.selectedScreen],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) => screenProvider.displayScreen(value),
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              const BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Store'),
              if (authNotifier.authenticated)
                const BottomNavigationBarItem(
                    icon: Icon(Icons.store), label: 'Purchase History')
            ],
            currentIndex: screenProvider.selectedScreen,
          ));
    });
  }
}
