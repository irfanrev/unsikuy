import 'package:flutter/material.dart';

import '../resources/resource.dart';

class AppTheme {
  static ThemeData buildThemeData(bool darkMode) {
    return ThemeData(
        primaryColor:
            (darkMode) ? AppColors.primaryDark : AppColors.primaryLight,
        colorScheme: ThemeData().colorScheme.copyWith(
              primary:
                  (darkMode) ? AppColors.primaryDark : AppColors.primaryLight,
              secondary: AppColors.colorSecondary,
            ),
        brightness: (darkMode) ? Brightness.light : Brightness.light,
        scaffoldBackgroundColor: (darkMode) ? AppColors.black : AppColors.white,
        backgroundColor: (darkMode) ? AppColors.black : AppColors.white,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        appBarTheme: (darkMode) ? darkAppBar() : lightAppBar(),
        fontFamily: 'Lato',
        floatingActionButtonTheme: FloatingActionButtonThemeData(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary:
                (darkMode) ? AppColors.primaryDark : AppColors.primaryLight,
          ),
        ),
        bottomNavigationBarTheme:
            (darkMode) ? darkNavigation() : lightNavigation(),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          headline2: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          headline3: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          headline4: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          headline5: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          headline6: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          bodyText1: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          bodyText2: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          subtitle1: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          subtitle2: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          caption: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w500,
          ),
        ),
        inputDecorationTheme: inputDecoration(darkMode),
        checkboxTheme: CheckboxTheme());
  }

  static CheckboxTheme() => CheckboxThemeData(
        side: BorderSide(width: 1, color: AppColors.textColour20),
        fillColor: MaterialStateProperty.resolveWith(
            (states) => AppColors.primaryLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
      );

  static AppBarTheme lightAppBar() {
    return AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      color: Colors.white,
      elevation: 0,
    );
  }

  static BottomNavigationBarThemeData lightNavigation() {
    return BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.black,
      selectedItemColor: Colors.deepOrangeAccent,
      elevation: 0,
    );
  }

  static AppBarTheme darkAppBar() {
    return AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      color: Colors.black,
      elevation: 0,
    );
  }

  static BottomNavigationBarThemeData darkNavigation() {
    return BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.deepOrangeAccent,
      elevation: 0,
    );
  }

  // Box Field
  static inputDecoration(bool darkMode) {
    return InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: AppColors.borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: AppColors.borderColor, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: AppColors.borderColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: AppColors.dangerBorder, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: AppColors.dangerBorder, width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(
              color:
                  (darkMode) ? AppColors.primaryDark : AppColors.primaryLight,
              width: 1),
        ),
        labelStyle: TextStyle(
          color:
              (darkMode) ? AppColors.white : Color.fromARGB(255, 132, 89, 89),
        ),
        hintStyle: TextStyle(color: AppColors.textHintColor, fontSize: 16),
        errorStyle: TextStyle(color: AppColors.error, fontSize: 12));
  }
}
