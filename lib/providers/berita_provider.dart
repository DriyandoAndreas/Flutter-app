import 'package:flutter/material.dart';
import 'package:app5/models/teras_sekolah_model.dart';
import 'package:app5/services/berita_service.dart';

class BeritaProvider with ChangeNotifier {
  final beritaService = BeritaService();
  //setter
  List<TerasSekolahModel> _list = [];
  List<TerasSekolahModel> _infinitelist = [];
  bool hasMore = true;
  int _limit = 10;
  //getter
  List<TerasSekolahModel> get list => _list;
  List<TerasSekolahModel> get infinitelist => _infinitelist;

  Future<void> fetchList({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    try {
      final beritaService = BeritaService();
      _list = await beritaService.getList(
        id: id,
        tokenss: tokenss,
        limit: limit,
      );

      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> infiniteLoad(
      {required String id, required String tokenss}) async {
    try {
      _limit += 10;
      List<TerasSekolahModel> respon =
          await beritaService.getList(id: id, tokenss: tokenss, limit: _limit);
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
    _list = [];
    _infinitelist = [];
    notifyListeners();
  }
}
