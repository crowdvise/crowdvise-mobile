import 'package:crowdvise/core/domain/model/custom_theme_mode.dart';
import 'package:crowdvise/core/presentation/manager/custom_provider.dart';
import 'package:crowdvise/core/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../di/core_module_container.dart';

class ThemeProvider extends CustomProvider with AppTheme {
  final _pref = getIt.getAsync<SharedPreferences>();
  bool isDark = true; 
  ThemeOptions? currentTheme;
  ThemeData? theme;
  ThemeData? darkThemeData;
  BuildContext context;

  ThemeProvider(this.context) {
    _pref.then((value) {
      getTheme();
    });
  }

   void getTheme() {
    _pref.then((value) {
      final themePref = value.getString(_themeKey) ?? 'Light';
      currentTheme =
          CustomThemeMode.customThemes[themePref]?.value ?? ThemeOptions.light;
      setTheme();
    });
  }

  void setTheme() {
    switch (currentTheme!) {
      case ThemeOptions.light:
        darkThemeData = null;
        theme = lightTheme();
        notifyListeners();
        isDark = false;
        break;
      case ThemeOptions.dark:
        darkThemeData = null;
        theme = darkTheme();
        notifyListeners();
        isDark = true;
        notifyListeners();
        break;
      case ThemeOptions.system:
        isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
        darkThemeData = darkTheme();
        theme = lightTheme();
        notifyListeners();
        break;
    }
  }

  void setThemeMode(CustomThemeMode themeMode) {
    currentTheme = themeMode.value;
    setTheme();
    _pref.then((value) {
      value.setString(_themeKey, themeMode.title);
    });
  }

  final _themeKey = 'isDark';
}
