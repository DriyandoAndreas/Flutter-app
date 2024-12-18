import 'package:flutter/material.dart';
import 'package:app5/models/akademik_model.dart';
import 'package:app5/services/akademik_service.dart';

class AkademikProvider with ChangeNotifier {
  final AkademikService service = AkademikService();
  AkademikModel? _list;
  AkademikModel? get list => _list;

  Future<void> getAkademik(
      {required String id, required String tokenss}) async {
    try {
      _list = await service.getAkademik(id: id, tokenss: tokenss);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> refresh({required String id, required String tokenss}) async {
    _list = AkademikModel();
    await getAkademik(id: id, tokenss: tokenss);
  }

  List<AkademikFormPersiapanPresensi> _presensi = [];
  List<AkademikFormPersiapanPresensi> get presensi => _presensi;
  Future<void> persiapanPresensi({
    required String id,
    required String tokenss,
    required String action,
    required String idakademik,
  }) async {
    try {
      _presensi = await service.persiapanPresensi(
          id: id, tokenss: tokenss, action: action, idakademik: idakademik);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  AkademikFormPersiapanLaporan? _laporan;
  AkademikFormPersiapanLaporan? get laporan => _laporan;

  Future<void> persiapanLaporan({
    required String id,
    required String tokenss,
    required String action,
    required String idakademik,
  }) async {
    try {
      _laporan = await service.persiapanLaporan(
          id: id, tokenss: tokenss, action: action, idakademik: idakademik);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  AkademikFormPersiapan? _persiapan;
  AkademikFormPersiapan? get persiapan => _persiapan;
  Future<void> persiapanPersiapan({
    required String id,
    required String tokenss,
    required String action,
    required String idakademik,
  }) async {
    try {
      _persiapan = await service.persiapan(
          id: id, tokenss: tokenss, action: action, idakademik: idakademik);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<MainPalapaMateri> _materi = [];
  List<MainPalapaMateri> get materi => _materi;

  Future<void> getMateri({required String token}) async {
    try {
      _materi = await service.getMateri(token: token);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  // *Sat
  List<AkademikKelas> _kelasList = [];

  List<AkademikKelas> get kelasList => _kelasList;

  Future<void> loadAkademikData({
    required String id,
    required String tokenss,
    required String date,
  }) async {
    try {
      _kelasList =
          await service.fetchAkademikData(id: id, tokenss: tokenss, date: date);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> clearState() async {
    _list = AkademikModel();
    _presensi = [];
    _persiapan = AkademikFormPersiapan();
    _laporan = AkademikFormPersiapanLaporan();
    _materi = [];
    notifyListeners();
  }
}
