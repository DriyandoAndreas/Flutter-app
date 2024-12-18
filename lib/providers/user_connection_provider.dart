import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserConnectionProvider with ChangeNotifier {
  UserConnectionProvider() {
    loaduserPreference();
  }
  // * testing
  bool _disconnected = false;
  bool get disconnected => _disconnected;
  void loaduserPreference() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _disconnected = prefs.getBool('disconnected') ?? false;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  // * testing
  void setDisconnect(bool status) async {
    _disconnected = status;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('disconnected', _disconnected);
    notifyListeners();
  }

  //*testing
  void removeStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('disconnected');
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}
