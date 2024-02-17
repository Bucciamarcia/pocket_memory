import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.lightBlue,
  ),
  useMaterial3: true,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(22)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000),
          side: const BorderSide(
            color: Colors.blue,
            width: 1,
          ),
        ),
      ),
      backgroundColor: MaterialStateProperty.all(Colors.lightBlue[50]),
      foregroundColor: MaterialStateProperty.all(Colors.black87),
      overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent),
      iconColor: MaterialStateProperty.all(Colors.black87),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          fontSize: 22,
        ),
      ),
    ),
  ),
);