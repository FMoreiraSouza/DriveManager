import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primarySwatch: Colors.green,
      hintColor: const Color.fromRGBO(0, 191, 99, 1),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.green,
        textTheme: ButtonTextTheme.primary,
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.green,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.green,
      ),
    );
  }
}
