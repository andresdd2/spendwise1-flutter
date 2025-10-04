import 'package:flutter/material.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    fontFamily: 'Outfit',
    scaffoldBackgroundColor: AppPalette.cBackground
  );
}