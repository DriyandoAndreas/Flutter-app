import 'package:flutter/material.dart';
import 'package:app5/models/uks_model.dart';
import 'package:app5/services/uks_service.dart';

/////////////////////////////////////
///******Gac Uks provider */
class UksProvider with ChangeNotifier {
  UksService uksService = UksService();
  int _limit = 10;
  bool hasMore = true;
  List<UksModel> _list = [];
  List<UksListKelasModel> _listKelas = [];
  List<UksListSiswaModel> _listSiswa = [];
  List<UksListObatModel> _listObat = [];
  List<UksModel> get list => _list;
  List<UksListKelasModel> get listKelas => _listKelas;
  List<UksListSiswaModel> get listSiswa => _listSiswa;
  List<UksListObatModel> get listObat => _listObat;

  Future<void> initList({
    required String id,
    required String tokenss,
  }) async {
    try {
      initInfiniteList(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> initListKelas({
    required String id,
    required String tokenss,
  }) async {
    try {
      initInfiniteListKelas(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> initListSiswa(
      {required String id,
      required String tokenss,
      required String kodeKelas}) async {
    try {
      initInfiniteListSiswa(id: id, tokenss: tokenss, kodeKelas: kodeKelas);
    } catch (e) {
      return;
    }
  }

  Future<void> initListObat({
    required String id,
    required String tokenss,
  }) async {
    try {
      initInfiniteListObat(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> initInfiniteList({
    required String id,
    required String tokenss,
  }) async {
    try {
      _limit += 10;
      List<UksModel> respon =
          await uksService.getList(id: id, tokenss: tokenss, limit: _limit);
      if (respon.length < _limit) {
        hasMore = false;
      }
      _list = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> initInfiniteListKelas({
    required String id,
    required String tokenss,
  }) async {
    try {
      _limit += 10;
      List<UksListKelasModel> respon = await uksService.getListKelas(
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

  Future<void> initInfiniteListObat({
    required String id,
    required String tokenss,
  }) async {
    try {
      List<UksListObatModel> respon =
          await uksService.getObat(id: id, tokenss: tokenss);
      _listObat = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> initInfiniteListSiswa({
    required String id,
    required String tokenss,
    required String kodeKelas,
  }) async {
    try {
      _limit += 10;
      List<UksListSiswaModel> respon = await uksService.getListSiswa(
          id: id, tokenss: tokenss, limit: _limit, kodeKelas: kodeKelas);
      if (respon.length < _limit) {
        hasMore = false;
      }
      _listSiswa = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> refresh({
    required String id,
    required String tokenss,
  }) async {
    try {
      _list = [];
      hasMore = true;
      await initInfiniteList(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> refreshKelas({
    required String id,
    required String tokenss,
  }) async {
    try {
      _listKelas = [];
      hasMore = true;
      await initInfiniteListKelas(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }
}

///////////////////////////////////
///***Sat uks provider */
class SatUksProvider with ChangeNotifier {
  SatUksService satUksService = SatUksService();
  List<SatUksModel> _ukssiswa = [];
  List<SatUksModel> get ukssiswa => _ukssiswa;

  Future<void> getList({
    required String id,
    required String tokenss,
  }) async {
    try {
      List<SatUksModel> respon =
          await satUksService.getList(id: id, tokenss: tokenss);
      _ukssiswa = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}
