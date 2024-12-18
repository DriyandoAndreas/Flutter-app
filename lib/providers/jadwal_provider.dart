import 'package:flutter/material.dart';
import 'package:app5/models/jadwal_model.dart';
import 'package:app5/services/jadwal_service.dart';

///****************Gac jadwal provider */
class JadwalProvider with ChangeNotifier {
  final JadwalService jadwalService = JadwalService();
  int _limit = 10;
  bool hasMore = true;
  List<JadwalModel> _listMapel = [];
  List<JadwalKelaslModel> _listKelas = [];
  List<DetailJadwalHarian> _listJadwalHarian = [];
  List<ListMengajarModel> _listMengajar = [];

  List<JadwalModel> get listMapel => _listMapel;
  List<JadwalKelaslModel> get listKelas => _listKelas;
  List<DetailJadwalHarian> get listJadwalHarian => _listJadwalHarian;
  List<ListMengajarModel> get listMengajar => _listMengajar;

  Future<void> initList({
    required String id,
    required String tokenss,
  }) async {
    try {
      await infinitMapel(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> initListKelas({
    required String id,
    required String tokenss,
  }) async {
    try {
      await infinitKelas(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> initJadwalHarian({
    required String id,
    required String tokenss,
    required String param3,
  }) async {
    try {
      await infinitJadwalHarian(id: id, tokenss: tokenss, param3: param3);
    } catch (e) {
      return;
    }
  }

  Future<void> initMengajar({
    required String id,
    required String tokenss,
    required String param3,
  }) async {
    try {
      await infinitMengajar(id: id, tokenss: tokenss, param3: param3);
    } catch (e) {
      return;
    }
  }

  Future<void> infinitMapel({
    required String id,
    required String tokenss,
  }) async {
    try {
      _limit += 10;
      List<JadwalModel> respon = await jadwalService.getListMapel(
          id: id, tokenss: tokenss, limit: _limit);

      if (respon.length < _limit) {
        hasMore = false;
      }
      _listMapel = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> infinitKelas({
    required String id,
    required String tokenss,
  }) async {
    try {
      _limit += 10;
      List<JadwalKelaslModel> respon = await jadwalService.getListKelas(
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

  Future<void> infinitJadwalHarian(
      {required String id,
      required String tokenss,
      required String param3}) async {
    try {
      List<DetailJadwalHarian> respon = await jadwalService.getListJadwalHarian(
          id: id, tokenss: tokenss, param3: param3);
      _listJadwalHarian = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> infinitMengajar(
      {required String id,
      required String tokenss,
      required String param3}) async {
    try {
      List<ListMengajarModel> respon = await jadwalService.getListMengajar(
          id: id, tokenss: tokenss, param3: param3);
      _listMengajar = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> refresh({required String id, required String tokenss}) async {
    _listMapel = [];
    hasMore = true;
    await infinitMapel(id: id, tokenss: tokenss);
  }

  Future<void> refreshKelas(
      {required String id, required String tokenss}) async {
    _listKelas = [];
    hasMore = true;
    await infinitKelas(id: id, tokenss: tokenss);
  }

  Future<void> refreshDetailJadwal(
      {required String id,
      required String tokenss,
      required String param3}) async {
    _listJadwalHarian = [];
    await infinitJadwalHarian(id: id, tokenss: tokenss, param3: param3);
  }

  Future<void> clearState() async {
    _listMapel = [];
    _listKelas = [];
    _listJadwalHarian = [];
    _listMengajar = [];
    notifyListeners();
  }
}

////////////////////////////////////////
///*****************Sat jadwal provider */
class SatJadwalProvider with ChangeNotifier {
  final SatJadwalService service = SatJadwalService();
  List<SatJadwalModel> _list = [];
  List<SatJadwalModel> get list => _list;

  Future<void> getList({required String id, required String tokenss}) async {
    try {
      List<SatJadwalModel> respon =
          await service.getJadwal(id: id, tokenss: tokenss);
      _list = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<SatJadwalUjianModel> _ujian = [];
  List<SatJadwalUjianModel> get ujian => _ujian;

  Future<void> getUjian({required String id, required String tokenss}) async {
    try {
      List<SatJadwalUjianModel> respon =
          await service.getJadwalUjian(id: id, tokenss: tokenss);
      _ujian = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<SatListJadwalKerjaPraktikModel> _kp = [];
  List<SatListJadwalKerjaPraktikModel> get kp => _kp;

  Future<void> getKp({required String id, required String tokenss}) async {
    try {
      List<SatListJadwalKerjaPraktikModel> respon =
          await service.getJadwalKP(id: id, tokenss: tokenss);
      _kp = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> clearState() async {
    _list = [];
    _ujian = [];
    _kp = [];
    notifyListeners();
  }
}
