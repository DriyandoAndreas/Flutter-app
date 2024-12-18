import 'package:flutter/material.dart';
import 'package:app5/models/pengumuman_model.dart';
import 'package:app5/services/pengumuman_service.dart';

class PengumumanProvider with ChangeNotifier {
  List<PengumumanModel> _listpengumuman = [];
  List<PengumumanModel> _infinitelist = [];
  bool hasMore = true;
  int _limit = 10;

  List<PengumumanModel> get listpengumuman => _listpengumuman;
  List<PengumumanModel> get infinitelist => _infinitelist;

  final pengumumanService = PengumumanService();
  Future<void> fetchPengumuman(
      {required String id, required String tokenss, required int limit}) async {
    try {
      _listpengumuman = await pengumumanService.getList(
          id: id, tokenss: tokenss, limit: limit);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> infiniteLoad(
      {required String id, required String tokenss}) async {
    try {
      _limit += 10;
      List<PengumumanModel> respon = await pengumumanService.getList(
          id: id, tokenss: tokenss, limit: _limit);
      if (respon.length < _limit) {
        hasMore = false;
      }
      _infinitelist = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> initInfinite({
    required String id,
    required String tokenss,
  }) async {
    await infiniteLoad(id: id, tokenss: tokenss);
  }

  Future<void> refresh({required String id, required String tokenss}) async {
    _infinitelist = [];
    hasMore = true;
    await infiniteLoad(id: id, tokenss: tokenss);
  }

  Future<void> clearState() async {
    _listpengumuman = [];
    _infinitelist = [];
    notifyListeners();
  }
}
