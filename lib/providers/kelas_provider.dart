import 'package:flutter/material.dart';
import 'package:sisko_v5/models/kelas_model.dart';
import 'package:sisko_v5/services/kelas_service.dart';

class KelasProvider with ChangeNotifier {
  final KelasService kelasSevice = KelasService();
  List<KelasModel> _infinitelist = [];
  List<KelasOpenModel> _infinitelistKelasOpen = [];
  int _limit = 10;
  bool hasMore = true;

  List<KelasModel> get infiniteList => _infinitelist;
  List<KelasOpenModel> get infiniteListKelasOpen => _infinitelistKelasOpen;

  Future<void> initList({required String id, required String tokenss}) async {
    try {
      await infiniteLoad(id: id, tokenss: tokenss);
    } catch (e) {
      throw Exception(e);
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
      throw Exception(e);
    }
  }
 
  Future<void> refresh({required String id, required String tokenss}) async {
    _infinitelist = [];
    hasMore = true;
    await infiniteLoad(id: id, tokenss: tokenss);
  }

  Future<void> initListKelasOpen({required String id, required String tokenss, required String kodeKelas}) async {
    try {
      await infiniteLoadKelasOpens(id: id, tokenss: tokenss, kodeKelas: kodeKelas);
    } catch (e) {
      throw Exception(e);
    }
  }
   Future<void> infiniteLoadKelasOpens(
      {required String id,
      required String tokenss,
      required String kodeKelas}) async {
    try {
      _limit += 10;
      List<KelasOpenModel> respon = await kelasSevice.getListKelas(
          id: id, tokenss: tokenss, limit: _limit, kodeKelas: kodeKelas);
      if (respon.length < _limit) {
        hasMore = false;
      }
      _infinitelistKelasOpen = respon;
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

   Future<void> refreshKelasOpen({required String id, required String tokenss, required String kodeKelas}) async {
    _infinitelistKelasOpen = [];
    hasMore = true;
    await infiniteLoadKelasOpens(id: id, tokenss: tokenss, kodeKelas: kodeKelas);
  }
}
