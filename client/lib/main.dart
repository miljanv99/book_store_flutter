import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/providers/booksProvider.provider.dart';
import 'package:book_store_flutter/providers/screenProvider.dart';
import 'package:book_store_flutter/screens/home.dart';
import 'package:book_store_flutter/screens/purchaseHistory.dart';
import 'package:book_store_flutter/screens/store.dart';
import 'package:book_store_flutter/widgets/cart/cart.widget.dart';
import 'package:book_store_flutter/widgets/drawer/drawer.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final isDark = sharedPreferences.getBool('is_dark') ?? false;
  runApp(MyApp(isDark: isDark));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  const MyApp({super.key, required this.isDark});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeSettings(isDark),
      builder: (context, child) {
        final settings = Provider.of<ThemeSettings>(context);
        return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: settings.currentTheme,
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => ScreenProvider()),
                ChangeNotifierProvider(
                    create: ((context) => AuthorizationProvider())),
                ChangeNotifierProvider(
                    create: ((context) => BookDetailsScreensProvider())),
                ChangeNotifierProvider(create: ((context) => BooksProvider())),
              ],
              child: const MyHomePage(title: 'Book Store'),
            ));
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer4<ScreenProvider, ThemeSettings, AuthorizationProvider,
            BooksProvider>(
        builder: (context, screenProvider, themeSettings, authNotifier,
            booksProvider, child) {
      List<Widget> screens = [
        Home(booksProvider: booksProvider),
        Store(booksProvider: booksProvider),
        const PurchaseHistory()
      ];


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
              CartWidget(authorizationProvider: authNotifier),
          ],
        ),
        drawer: DrawerWidget(
          authorizationProvider: authNotifier,
          themeSettings: themeSettings,
        ),
        body: screens[screenProvider.selectedScreen],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blueAccent,
          onTap: (value) => screenProvider.displayScreen(value),
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Home'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.store), label: 'Store'),
            if (authNotifier.authenticated)
              const BottomNavigationBarItem(
                  icon: Icon(Icons.store), label: 'Purchase History')
          ],
          currentIndex: screenProvider.selectedScreen,
        ),    
      );
    });
  }
}
