import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSwitchProvider with ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeSwitchProvider() {
    _loadThemePreference();
  }
  void _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? false;
    notifyListeners();
  }

  void toggle(bool value) async {
    _isDark = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', _isDark);
    notifyListeners();
  }
}
