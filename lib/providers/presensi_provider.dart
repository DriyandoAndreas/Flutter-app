import 'package:flutter/material.dart';
import 'package:app5/models/presensi_model.dart';
import 'package:app5/services/presensi_service.dart';

///*********Gac Presensi Provider */
class PresensiProvider with ChangeNotifier {
  final presensiServie = PresensiService();
  bool _isLoading = false;
  List<PresensiModel> _list = [];
  List<PresensiKelasOpenModel> _listKelasOpen = [];
  List<PresensiModel> get list => _list;
  List<PresensiKelasOpenModel> get listKelasOpen => _listKelasOpen;
  bool get isLoading => _isLoading;

  Future<void> initList({required String id, required String tokenss}) async {
    try {
      List<PresensiModel> respon =
          await presensiServie.getList(id: id, tokenss: tokenss);
      _list = respon;

      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> initKelasOpen(
      {required String id,
      required String tokenss,
      required String kodeKelas}) async {
    try {
      if (_isLoading) {
        return;
      }
      _isLoading = true;
      List<PresensiKelasOpenModel> respon = await presensiServie.getKelasOpen(
          id: id, tokenss: tokenss, kodeKelas: kodeKelas);
      _listKelasOpen = respon;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> refresh({required String id, required String tokenss}) async {
    try {
      _list = [];
      await initList(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }
}

///*********Sat Presensi Provider */

class SatPresensiProvider with ChangeNotifier {
  SatPresensiService presensiService = SatPresensiService();

  Map<String, dynamic>? _presensi;
  Map<String, dynamic>? get presensi => _presensi;
  Future<void> getPresensiBulanan({
    required String id,
    required String tokenss,
    required String kode,
    required String tglabsensi,
  }) async {
    try {
      _presensi = await presensiService.getPresensiBulanan(
          id: id, tokenss: tokenss, kode: kode, tglabsensi: tglabsensi);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Map<String, dynamic> _presensiSum = {};
  Map<String, dynamic> get presensiSum => _presensiSum;
  Future<void> getpresensisum({
    required String id,
    required String tokenss,
    required String kode,
    required String tglabsensi,
  }) async {
    try {
      _presensiSum = await presensiService.getPresensiSum(
          id: id, tokenss: tokenss, kode: kode, tglabsensi: tglabsensi);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<SatPresensiHistoryModel> _datahistory = [];
  List<SatPresensiHistoryModel> get datahistory => _datahistory;

  Future<void> getpresensihistory({
    required String id,
    required String tokenss,
    required String kode,
  }) async {
    try {
      _datahistory = await presensiService.getHistory(
          id: id, tokenss: tokenss, kode: kode);
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}
