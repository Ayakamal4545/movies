import 'package:flutter/material.dart';
import 'package:movies/app_colors.dart';

class MyThemeData{
  static final ThemeData lightTheme= ThemeData(
      primaryColor: AppColors.blackColor,
      scaffoldBackgroundColor: AppColors.blackColor,
      textTheme: TextTheme(
        titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor),
        titleMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor
        ),
        titleSmall: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor
        ),
      ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.blackColor,
      selectedItemColor: AppColors.selectColor,
      unselectedItemColor: AppColors.greyColor,
    ),
  cardColor: Colors.grey[850], // Background color for cards
  buttonTheme: ButtonThemeData(
  buttonColor: AppColors.selectColor, // Button background color
  textTheme: ButtonTextTheme.primary,
  ),
  );
}