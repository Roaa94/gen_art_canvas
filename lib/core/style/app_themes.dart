import 'package:flutter/material.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';

class AppThemes {
  static ThemeData get theme => ThemeData(
        fontFamily: 'Raleway',
        scaffoldBackgroundColor: AppColors.firebaseDarkGrey,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.firebaseDarkGrey,
          modalElevation: 0,
          elevation: 0,
        ),
      );
}
