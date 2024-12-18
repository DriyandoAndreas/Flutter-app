import 'package:flutter/material.dart';
import 'package:app5/models/perpus_model.dart';
import 'package:app5/services/perpus_service.dart';

///******Gac perpus provider */
class PerpusProvider with ChangeNotifier {
  PerpusService perpusService = PerpusService();
  List<PerpusModel> _list = [];
  bool hasMore = true;
  int _limit = 10;

  List<PerpusModel> get list => _list;

  Future<void> initList({required String id, required String tokenss}) async {
    try {
      await initInfiniteList(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> initInfiniteList(
      {required String id, required String tokenss}) async {
    try {
      _limit += 10;
      List<PerpusModel> respon =
          await perpusService.getList(id: id, tokenss: tokenss, limit: _limit);
      if (respon.length < _limit) {
        hasMore = false;
      }
      _list = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> refresh({required String id, required String tokenss}) async {
    _list = [];
    hasMore = true;
    await initList(id: id, tokenss: tokenss);
  }
}

///******Sat perpus provider */
class SatPerpusProvider with ChangeNotifier {
  SatPerpusService perpusService = SatPerpusService();
  List<SatPerpusModel> _list = [];

  List<SatPerpusModel> get list => _list;

  Future<void> getList({required String id, required String tokenss}) async {
    try {
      List<SatPerpusModel> respon =
          await perpusService.getList(id: id, tokenss: tokenss);
      _list = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}
