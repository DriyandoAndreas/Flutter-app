import 'package:flutter/material.dart';
import 'package:sisko_v5/models/user_info_model.dart';
import 'package:sisko_v5/services/user_info_service.dart';

class UserInfoProvider with ChangeNotifier {
  late InfoModel _userInfo = InfoModel();

  InfoModel get userInfo => _userInfo;

  set userInfo(InfoModel userInfo) {
    _userInfo = userInfo;
    notifyListeners();
  }

  Future<bool> getUserInfo({required String token}) async {
    try {
      InfoModel userInfo = await UserInfo().getinfo(token: token);
      _userInfo = userInfo;
      return true;
    } catch (e) {
      return false;
    }
  }
}
