import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    surfaceContainer: Colors.grey.shade300,
    primary: Colors.black,
    secondary: Colors.grey.shade600,
    tertiary: const Color.fromARGB(255, 121, 120, 120),
    primaryFixed: Colors.grey.shade200,
  ),
);
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.black,
    primary: Colors.white,
    secondary: Colors.grey.shade900,
    onPrimary: Colors.grey.shade900,
    tertiary: const Color.fromARGB(255, 121, 120, 120),
    primaryFixed: Colors.grey.shade900,
  ),
);
