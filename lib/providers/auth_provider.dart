import 'package:flutter/material.dart';
import 'package:app5/models/user_model.dart';
import 'package:app5/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  late UserModel _userModels = UserModel();

  UserModel get user => _userModels;

  set user(UserModel user) {
    _userModels = user;
    notifyListeners();
  }

  Future<bool> login({
    required String action,
    required String hp,
    required String password,
  }) async {
    try {
      UserModel user = await AuthService().login(
        action: action,
        hp: hp,
        password: password,
      );
      _userModels = user;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
