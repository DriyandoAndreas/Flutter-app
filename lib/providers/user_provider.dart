import 'package:flutter/material.dart';
import 'package:app5/models/user_model.dart';
import 'package:app5/services/user_service.dart';

class UserProvider with ChangeNotifier {
  UserService service = UserService();
  List<RegisterNumberAt> _list = [];
  List<RegisterNumberAt> get list => _list;

  Future<void> getRegisterAt({required String token}) async {
    try {
      _list = await service.getRegisterNumber(token: token);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  UserJoinData? _join;
  UserJoinData? get join => _join;

  Future<void> getJoinData({
    required String token,
    required String action,
    required String npsn,
    required String hp,
    required String nomor,
    required String emailuser,
  }) async {
    try {
      _join = await service.join(
        token: token,
        action: action,
        npsn: npsn,
        hp: hp,
        nomor: nomor,
        emailuser: emailuser,
      );
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}
