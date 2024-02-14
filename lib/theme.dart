import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.lightBlue,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.white,
  ),
  useMaterial3: true,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
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