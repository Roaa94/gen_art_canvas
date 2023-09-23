import 'package:flutter/material.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';

class AppThemes {
  static ThemeData get theme => ThemeData(
        fontFamily: 'Raleway',
        scaffoldBackgroundColor: AppColors.firebaseDarkGrey,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.firebaseAmber,
          brightness: Brightness.dark,
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: AppColors.firebaseDarkGrey,
          elevation: 0,
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
        ),
      );
}
