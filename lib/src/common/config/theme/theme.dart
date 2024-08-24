import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.purple,
        ),
        cardTheme: const CardTheme(
          clipBehavior: Clip.antiAlias,
        ),
      );

  static ThemeData get darkTheme => ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.purple,
        ),
        cardTheme: const CardTheme(
          clipBehavior: Clip.antiAlias,
        ),
      );
}
