import 'package:flutter/material.dart';

class ScreenProvider extends ChangeNotifier {
  int selectedScreen = 0;
  String title= '';

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
  String title= '';

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

