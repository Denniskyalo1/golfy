import 'package:flutter/material.dart';

const primaryWhite = Color(0xFFf4f4f4);
const darkPrimaryGreen = Color(0xFF091a12);

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: ColorScheme.light(
      primary: primaryWhite,
      secondary: primaryWhite,
      background: primaryWhite,
      surface: primaryWhite,
      onPrimary: primaryWhite,
      onSurface: Colors.black87,
      onSecondary: Colors.grey,
      onError: Colors.red,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: darkPrimaryGreen,
    secondary: darkPrimaryGreen,
    background: const Color(0xFF05021c),
    surface: const Color(0xFF111827),
    onPrimary: primaryWhite,
    onSurface: primaryWhite,
    onSecondary: Colors.grey,
    onError:Colors.red,
  ),
);
