import 'package:flutter/material.dart';
import 'package:app5/models/kelas_model.dart';
import 'package:app5/services/kelas_service.dart';

//***class GAC proivder
class KelasProvider with ChangeNotifier {
  final KelasService kelasSevice = KelasService();
  List<KelasModel> _infinitelist = [];
  List<KelasOpenModel> _infinitelistKelasOpen = [];
  int _limit = 10;
  bool hasMore = true;
  bool _isLoading = false;

  List<KelasModel> get infiniteList => _infinitelist;
  List<KelasOpenModel> get infiniteListKelasOpen => _infinitelistKelasOpen;
  bool get isLoading => _isLoading;

  Future<void> initList({required String id, required String tokenss}) async {
    try {
      await infiniteLoad(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> infiniteLoad(
      {required String id, required String tokenss}) async {
    try {
      _limit += 10;
      List<KelasModel> respon =
          await kelasSevice.getKelas(id: id, tokenss: tokenss, limit: _limit);

      if (respon.length < _limit) {
        hasMore = false;
      }
      _infinitelist = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> refresh({required String id, required String tokenss}) async {
    _infinitelist = [];
    hasMore = true;
    await infiniteLoad(id: id, tokenss: tokenss);
  }

  Future<void> initListKelasOpen(
      {required String id,
      required String tokenss,
      required String kodeKelas}) async {
    try {
      await infiniteLoadKelasOpens(
          id: id, tokenss: tokenss, kodeKelas: kodeKelas);
    } catch (e) {
      return;
    }
  }

  Future<void> infiniteLoadKelasOpens(
      {required String id,
      required String tokenss,
      required String kodeKelas}) async {
    try {
      if (_isLoading) {
        return;
      }
      _isLoading = true;
      _limit += 10;
      List<KelasOpenModel> respon = await kelasSevice.getListKelas(
          id: id, tokenss: tokenss, limit: _limit, kodeKelas: kodeKelas);
      if (respon.length < _limit) {
        hasMore = false;
      }
      _infinitelistKelasOpen = respon;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> refreshKelasOpen(
      {required String id,
      required String tokenss,
      required String kodeKelas}) async {
    _infinitelistKelasOpen = [];
    hasMore = true;
    await infiniteLoadKelasOpens(
        id: id, tokenss: tokenss, kodeKelas: kodeKelas);
  }

  Future<void> clearState() async {
    _infinitelist = [];
    _infinitelistKelasOpen = [];
    notifyListeners();
  }
}

//*** */ class SAT provider
class KelasSatProvider with ChangeNotifier {
  //code here
  KelasSatService kelasSatService = KelasSatService();
  List<KelasSatModel> _listkelas = [];
  List<KelasSatModel> get listkelas => _listkelas;

  Future<void> getListKelas({
    required String id,
    required String tokenss,
  }) async {
    try {
      List<KelasSatModel> respon =
          await kelasSatService.getSatKelas(id: id, tokenss: tokenss);
      _listkelas = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<KelasSatOpenModel> _listKelasOpen = [];
  List<KelasSatOpenModel> get listKelasOpen => _listKelasOpen;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<void> getKelasOpen({
    required String id,
    required String tokenss,
    required String kodeKelas,
  }) async {
    try {
      if (_isLoading) {
        return;
      }
      _isLoading = true;
      List<KelasSatOpenModel> respon = await kelasSatService.getKelasOpen(
          id: id, tokenss: tokenss, kodeKelas: kodeKelas);
      _listKelasOpen = respon;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> clearState() async {
    _listkelas = [];
    _listKelasOpen = [];
    notifyListeners();
  }
}
