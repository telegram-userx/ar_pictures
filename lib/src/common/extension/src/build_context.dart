import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Size get size => mediaQuery.size;
  double get width => mediaQuery.size.width;
  double get height => mediaQuery.size.height;
}
