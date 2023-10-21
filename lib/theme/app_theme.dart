import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData appTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: 
        BorderRadius.vertical(
          bottom: Radius.circular(20)
        )
      ),
    ),
  );
}
