import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/theme/colors/snack_bar_colors.dart';
import 'package:crowdvise/core/presentation/theme/my_text_theme.dart';
import 'package:flutter/material.dart';

mixin AppTheme {
  ThemeData lightTheme() {
    return ThemeData.from(
      colorScheme: const ColorScheme.light(
        surface: Colors.white,
        onSurface: white,
        tertiary: Color(0xFFA9D478), //textAccentLight,
        secondary: Color(0xffDBE3F3),
        error: errorForeground,
      ),
    ).copyWith(
      scaffoldBackgroundColor: const Color(0xffF8F8F8),
      primaryColor: _buttonLightColor,
      splashFactory: NoSplash.splashFactory,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _buttonLightColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      dividerColor: neutral300,
      cardTheme: CardThemeData(
        color: const Color(0xffF7F7F8),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(
          color: Color(0xFFA4A7AE),
          fontFamily: 'PlusJakartaSans',
          fontSize: 14,
        ),
        
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        filled: true,
        fillColor: Color(0xFF2A2A2A),
        errorStyle: const TextStyle(
          color: errorForeground,
          fontFamily: 'PlusJakartaSans',
          fontSize: 14,
        ),
        border: _inputBorderLight,
        enabledBorder: _emptyInputBorderLight,
        focusedBorder: _inputBorderLight,
        disabledBorder: _emptyInputBorderLight,
        errorBorder: _errorInputBorderLight,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonLightColor,
          disabledBackgroundColor: Colors.grey,
          minimumSize: const Size(double.infinity, double.infinity),
          foregroundColor: Colors.white,

          shadowColor: const Color(0xFF0A43CA).withValues(alpha: .05),
          textStyle: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          overlayColor: Colors.white,
          splashFactory: NoSplash.splashFactory,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: const Color(0xFF1e1e1e),
        selectionColor: const Color(0xFF1e1e1e).withValues(alpha: .05),
        selectionHandleColor: const Color(0xFF1e1e1e).withValues(alpha: .07),
      ),
      textTheme: MyTextTheme.lightTextTheme,
    );
  }

  ThemeData darkTheme() {
    return ThemeData.from(
      colorScheme: const ColorScheme.dark(
        surface: Color(0xff010101),
        onSurface: Color(0xFFEAEDEF),
        tertiary: Color(0xFFA9D478), //textAccentDark,
        secondary: Color(0xff13171A),
      ),
    ).copyWith(
      scaffoldBackgroundColor: const Color(0xff010101),
      cardColor: const Color(0xFF0F1A1C),
      primaryColor: _buttonDarkColor,
      splashFactory: NoSplash.splashFactory,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _buttonDarkColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),

      cardTheme: CardThemeData(
        color: const Color(0xffF7F7F8),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(
          color: Color(0xFF959595),
          fontFamily: 'PlusJakartaSans',
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        filled: true,
        fillColor: const Color(0xff191D20),
        errorStyle: const TextStyle(
          color: errorForeground,
          fontFamily: 'PlusJakartaSans',
          fontSize: 14,
        ),
        border: _inputBorderDark,
        enabledBorder: _inputBorderDark,
        focusedBorder: _inputBorderDark,
        disabledBorder: _inputBorderDark,
        errorBorder: _inputBorderDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonDarkColor,
          disabledBackgroundColor: Colors.grey,
          minimumSize: const Size(double.infinity, double.infinity),
          foregroundColor: Colors.white,
          shadowColor: const Color(0xFF0A43CA).withValues(alpha: .05),
          textStyle: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFFEAEDEF),
          ),
          splashFactory: NoSplash.splashFactory,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: const Color(0xFFEAEDEF),
        selectionColor: const Color(0xFFEAEDEF).withValues(alpha: .05),
        selectionHandleColor: const Color(0xFFEAEDEF).withValues(alpha: .07),
      ),
      textTheme: MyTextTheme.darkTextTheme,
    );
  }

  static const _buttonLightColor = Color(0xFF000000);
  // static const _buttonDarkColor = Color(0xFFFFFFFF);
  static const _buttonDarkColor = Color(0xFFA9D478);

  static final _inputBorderLight = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: electricBlue),
  );
  static final _errorInputBorderLight = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: error400),
  );
  static final _emptyInputBorderLight = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
  );

  static final _inputBorderDark = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    // borderSide: BorderSide.none,
    borderSide: const BorderSide(color: Color(0xffe4e4e4)),
  );
}
