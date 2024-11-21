import 'package:flutter/material.dart';
import 'package:todoapp/style/AppColors.dart';

class AppStyle {
  static ThemeData lightTheme = ThemeData(
    iconTheme: IconThemeData(color: Colors.white),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: StadiumBorder(side: BorderSide(color: Colors.white, width: 5)),
        backgroundColor: AppColors.lightPrimary),
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: AppBarTheme(
        toolbarHeight: 120,
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            fontSize: 22),
        iconTheme: IconThemeData(color: Colors.white)),
    textTheme: TextTheme(
      titleSmall: TextStyle(
        fontFamily: "Poppins",
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w700
      ),
        labelSmall: TextStyle(
      color: Colors.black,
      fontSize: 12,
    )),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      primary: AppColors.lightPrimary,
    ),
    useMaterial3: false,
  );
}
