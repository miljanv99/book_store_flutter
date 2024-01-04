import 'package:flutter/widgets.dart';

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

const double maxPhoneWidth = 600.0;

double calculateMaxWidth(BuildContext context) {
  double screenWidth = getScreenWidth(context);
  return screenWidth < maxPhoneWidth ? screenWidth : maxPhoneWidth;
}