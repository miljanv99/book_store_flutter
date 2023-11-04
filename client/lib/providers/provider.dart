import 'package:flutter/material.dart';

class ScreenProvider extends ChangeNotifier {
  int selectedScreen = 0;

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
}

