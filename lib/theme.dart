import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.lightBlue,
  ),
  useMaterial3: true,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(EdgeInsets.all(22)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000),
          side: const BorderSide(
            color: Colors.blue,
            width: 1,
          ),
        ),
      ),
      backgroundColor: MaterialStateProperty.all(Colors.white),
      overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent),
      iconColor: MaterialStateProperty.all(Colors.black87),
      textStyle: MaterialStateProperty.all(
        TextStyle(
          foreground: Paint()..color = Colors.black87,
          fontSize: 22,
        ),
      ),
    ),
  ),
);