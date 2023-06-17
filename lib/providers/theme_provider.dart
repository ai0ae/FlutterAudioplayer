import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/themes/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeType { light, dark, orange }

const kThemeKey = "theme";

class ThemeProvider extends ChangeNotifier { //Theme Switching (30 points): Enhance your
// app by implementing a theme switching
// functionality that allows users to change
// between different themes
  ThemeData _currentTheme;

  ThemeProvider({required ThemeData initialTheme})
      : _currentTheme = initialTheme;

  ThemeData get currentTheme => _currentTheme;

  void setTheme(ThemeType type) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString(kThemeKey, type.name.toString());
    _currentTheme = getThemeFromEnum(type);
    notifyListeners();
  }

  // getTheme() async {
    
  //   _currentTheme = theme;
  // }
}

ThemeData getThemeFromEnum(ThemeType type) {
  switch (type) {
    case ThemeType.light:
      return lightTheme;
    case ThemeType.dark:
      return darkTheme;
    case ThemeType.orange:
      return theme3;
    default:
      return lightTheme;
  }
}
