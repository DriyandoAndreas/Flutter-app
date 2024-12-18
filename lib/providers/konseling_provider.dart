import 'package:flutter/material.dart';
import 'package:app5/models/konseling_model.dart';
import 'package:app5/services/konseling_service.dart';

///*************Gac konseling provider */
class KonselingProvider with ChangeNotifier {
  final KonselingService konselingService = KonselingService();
  List<KonselingModel> _list = [];
  List<ShowKelasModel> _listKelas = [];
  List<PoinModel> _listPoin = [];
  int _limit = 10;
  bool hasMore = true;
  List<KonselingModel> get list => _list;
  List<ShowKelasModel> get listKelas => _listKelas;
  List<PoinModel> get listPoin => _listPoin;

  Future<void> initList({required String id, required String tokenss}) async {
    try {
      await infiniteList(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> initKelas({required String id, required String tokenss}) async {
    try {
      await infinitKelas(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> initPoin({required String id, required String tokenss}) async {
    try {
      await infinitPoin(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> infiniteList(
      {required String id, required String tokenss}) async {
    try {
      _limit += 10;
      List<KonselingModel> respon = await konselingService.getList(
          id: id, tokenss: tokenss, limit: _limit);
      if (respon.length < _limit) {
        hasMore = false;
      }
      _list = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> infinitKelas(
      {required String id, required String tokenss}) async {
    try {
      _limit += 10;
      List<ShowKelasModel> respon = await konselingService.showKelas(
          id: id, tokenss: tokenss, limit: _limit);
      if (respon.length < _limit) {
        hasMore = false;
      }
      _listKelas = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> infinitPoin(
      {required String id, required String tokenss}) async {
    try {
      _limit += 10;
      List<PoinModel> respon =
          await konselingService.getPoin(id: id, tokenss: tokenss);
      if (respon.length < _limit) {
        hasMore = false;
      }
      _listPoin = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> refresh({required String id, required String tokenss}) async {
    _list = [];
    hasMore = true;
    await infiniteList(id: id, tokenss: tokenss);
  }

  Future<void> refreshKelas(
      {required String id, required String tokenss}) async {
    _listKelas = [];
    hasMore = true;
    await infinitKelas(id: id, tokenss: tokenss);
  }

  Future<void> clearState() async {
    _list = [];
    _listKelas = [];
    _listPoin = [];
    notifyListeners();
  }
}

/////////////////////////////////////////////////
///*******************Sat konseling provider */
class SatKonselingProvider with ChangeNotifier {
  SatKonselingService service = SatKonselingService();
  List<SatKonselingModel> _list = [];
  List<SatKonselingModel> get list => _list;

  Future<void> getList({
    required String id,
    required String tokenss,
  }) async {
    try {
      //
      List<SatKonselingModel> respon =
          await service.getList(id: id, tokenss: tokenss);
      _list = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> clearState() async {
    _list = [];
    notifyListeners();
  }
}
