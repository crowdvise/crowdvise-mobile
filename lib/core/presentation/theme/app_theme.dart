import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/theme/colors/snack_bar_colors.dart';
import 'package:crowdvise/core/presentation/theme/my_text_theme.dart';
import 'package:flutter/material.dart';

/// Single dark theme. One accent (signal), flat surfaces, 1px hairlines.
mixin AppTheme {
  ThemeData lightTheme() => _theme(MyTextTheme.lightTextTheme);
  ThemeData darkTheme() => _theme(MyTextTheme.darkTextTheme);

  ThemeData _theme(TextTheme textTheme) {
    return ThemeData.from(
      colorScheme: const ColorScheme.dark(
        surface: wsCanvas,
        onSurface: textPrimary,
        primary: signal,
        onPrimary: white,
        secondary: wsCard,
        tertiary: statusReady,
        error: errorForeground,
        outline: hairline,
      ),
    ).copyWith(
      scaffoldBackgroundColor: wsCanvas,
      canvasColor: wsCanvas,
      cardColor: wsCard,
      primaryColor: signal,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.white.withValues(alpha: 0.03),
      dividerColor: hairline,
      visualDensity: VisualDensity.compact,
      cardTheme: CardThemeData(
        color: wsCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: hairline),
        ),
      ),
      inputDecorationTheme: _inputDecorationTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textSecondary,
          splashFactory: NoSplash.splashFactory,
          textStyle: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: textSecondary, size: 20),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: wsCard,
        surfaceTintColor: Colors.transparent,
        showDragHandle: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: wsCard,
        surfaceTintColor: Colors.transparent,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: wsCardHover,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: hairline),
        ),
        textStyle: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 12,
          color: textPrimary,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: signal,
        selectionColor: signal.withValues(alpha: 0.25),
        selectionHandleColor: signal,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: signal,
        linearTrackColor: hairline,
        circularTrackColor: hairline,
      ),
      textTheme: textTheme,
    );
  }

  static final _inputDecorationTheme = InputDecorationTheme(
    hintStyle: const TextStyle(
      color: textTertiary,
      fontFamily: 'PlusJakartaSans',
      fontSize: 14,
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
    filled: true,
    fillColor: wsCard,
    isDense: true,
    errorStyle: const TextStyle(
      color: errorForeground,
      fontFamily: 'PlusJakartaSans',
      fontSize: 12.5,
    ),
    border: _inputBorder,
    enabledBorder: _inputBorder,
    focusedBorder: _inputBorderFocused,
    disabledBorder: _inputBorder,
    errorBorder: _inputBorderError,
    focusedErrorBorder: _inputBorderError,
  );

  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: signal,
      disabledBackgroundColor: wsCardHover,
      minimumSize: const Size(double.infinity, 44),
      foregroundColor: white,
      elevation: 0,
      textStyle: const TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: white,
      ),
      splashFactory: NoSplash.splashFactory,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

  static final _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: hairlineStrong),
  );

  static final _inputBorderFocused = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: signal, width: 1.2),
  );

  static final _inputBorderError = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: error400),
  );
}
