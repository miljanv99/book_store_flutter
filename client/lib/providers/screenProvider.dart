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

