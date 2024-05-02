import 'package:flutter/material.dart';
import '../utils/screenWidth.dart';

class SnackBarNotification {
  static void show(BuildContext context, String message, Color backgroundColor) {
    double maxWidth = calculateMaxWidth(context) - 5;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: maxWidth,
        content: Text(message, style: TextStyle(color: Colors.white),),
        showCloseIcon: true,
        closeIconColor: Colors.white,
        duration: const Duration(seconds: 3),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
