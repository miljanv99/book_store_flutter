import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenProvider extends ChangeNotifier {
  int selectedScreen = 0;
  String title = '';

  void displayScreen(index) {
    selectedScreen = index;
    notifyListeners();
  }

  void selectFirstScreen() {
    selectedScreen = 0;
    notifyListeners();
  }

  void selectSecondScreen() {
    selectedScreen = 1;
    notifyListeners();
  }

  void selectThirdScreen() {
    selectedScreen = 2;

    notifyListeners();
  }
}

class BookDetailsScreensProvider extends ChangeNotifier {
  int selectedBookScreen = 0;
  String title = '';

  void displayBookScreen(index) {
    selectedBookScreen = index;
    notifyListeners();
  }

  void selectBookDetails() {
    selectedBookScreen = 0;
    notifyListeners();
  }

  void selectComments() {
    selectedBookScreen = 1;
    notifyListeners();
  }
}

class ThemeSettings extends ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();
  ThemeData get currentTheme => _currentTheme;

  ThemeSettings(bool isDark) {
    if (isDark) {
      _currentTheme = ThemeData.dark();
    } else {
      _currentTheme = ThemeData.light();
    }
  }

  void toggleTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (_currentTheme == ThemeData.light()) {
      _currentTheme = ThemeData.dark();
      sharedPreferences.setBool('is_dark', true);
    } else {
      _currentTheme = ThemeData.light();
      sharedPreferences.setBool('is_dark', false);
    }
    notifyListeners();
  }
}
