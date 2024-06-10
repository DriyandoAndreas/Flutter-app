import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      surface: Color.fromARGB(255, 233, 233, 233),
      primary: Colors.black,
      onPrimary: Colors.white,
    ));
ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        surface: Color.fromARGB(28, 167, 165, 165),
        onSecondary: Colors.white,
        primary: Colors.white));
