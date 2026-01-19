import 'package:flutter/material.dart';

class NavigationHelper {
  void navigateToHomePage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }
}