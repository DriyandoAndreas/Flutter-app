import 'package:flutter/material.dart';
import 'package:app5/models/monitoring_model.dart';
import 'package:app5/services/monitoring_service.dart';

class MonitoringProvider with ChangeNotifier {
  final MonitoringService service = MonitoringService();
  List<UserMonitoringAktifitasModel> _getUserGrAll = [];
  List<UserMonitoringAktifitasModel> get getGrAll => _getUserGrAll;
  List<UserMonitoringAktifitasModel> _getUserGr = [];
  List<UserMonitoringAktifitasModel> get getGr => _getUserGr;
  List<UserMonitoringAktifitasModel> _getUserKrAll = [];
  List<UserMonitoringAktifitasModel> get getKrAll => _getUserKrAll;
  List<UserMonitoringAktifitasModel> _getUserKr = [];
  List<UserMonitoringAktifitasModel> get getKr => _getUserKr;
  List<UserMonitoringAktifitasModel> _getUserXtAll = [];
  List<UserMonitoringAktifitasModel> get getXtAll => _getUserXtAll;
  List<UserMonitoringAktifitasModel> _getUserXt = [];
  List<UserMonitoringAktifitasModel> get getXt => _getUserXt;

  Future<void> getListUser(
      {required String id, required String tokenss}) async {
    try {
      MainUserMonitoringModel respon =
          await service.getUser(id: id, tokenss: tokenss);
      _getUserGrAll = respon.getGrAll ?? [];
      _getUserGr = respon.getGr ?? [];
      _getUserKrAll = respon.getKrAll ?? [];
      _getUserKr = respon.getKr ?? [];
      _getUserXtAll = respon.getXtAll ?? [];
      _getUserXt = respon.getXt ?? [];
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  MainListAktifitasModel _aktifitas =
      MainListAktifitasModel(guru: [], karyawan: [], extra: []);
  MainListAktifitasModel get aktifitas => _aktifitas;

  Future<void> fetchAktifitas(
      {required String id, required String tokenss}) async {
    try {
      MainListAktifitasModel data =
          await service.getList(id: id, tokenss: tokenss);
      _aktifitas = data;
      notifyListeners();
    } catch (error) {
      throw Exception(error);
    }
  }

  List<MonitoringProgressGrouped>? _groups;
  List<MonitoringProgressGrouped>? get groups => _groups;

  final MonitoringService _service = MonitoringService();

  Future<void> getProgress({
    required String id,
    required String tokenss,
  }) async {
    try {
      _groups = await _service.getImplementasi(id: id, tokenss: tokenss);
      notifyListeners();
    } catch (e) {
      e.toString();
    }
  }

  late MonitoringKoneksiPhone _monitoringKoneksi = MonitoringKoneksiPhone();
  MonitoringKoneksiPhone get monitoringKoneksi => _monitoringKoneksi;

  Future<void> getKoneksi({required String id, required String tokenss}) async {
    try {
      _monitoringKoneksi = await service.getKoneksi(id: id, tokenss: tokenss);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Monitoring30DayGrouped? _monitoringData;
  Monitoring30DayGrouped? get monitoringData => _monitoringData;

  Future<void> getAktivitas30Day({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    try {
      _monitoringData =
          await service.getList30day(id: id, tokenss: tokenss, limit: limit);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<MonitoringActivitySummaryModel> _acguru = [];
  List<MonitoringActivitySummaryModel> _ackaryawan = [];
  List<MonitoringActivitySummaryModel> get acguru => _acguru;
  List<MonitoringActivitySummaryModel> get ackaryawan => _ackaryawan;
  Future<void> getActivitySummary({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    try {
      List<MonitoringActivitySummaryModel> datagr =
          await service.getActivityGuru(id: id, tokenss: tokenss, limit: limit);
      List<MonitoringActivitySummaryModel> datakr =
          await service.getActivityKaryawan(id: id, tokenss: tokenss);
      _acguru = datagr;
      _ackaryawan = datakr;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<MonitoriActivitySummaryTotal> _totalactivityguru = [];
  List<MonitoriActivitySummaryTotal> get totalactivityguru =>
      _totalactivityguru;

  Future<void> getTotalActivityGuru({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    try {
      _totalactivityguru = await service.getTotalActivityGuru(
          id: id, tokenss: tokenss, limit: limit);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<MonitoriActivitySummaryTotal> _totalactivitykaryawan = [];
  List<MonitoriActivitySummaryTotal> get totalactivitykaryawan =>
      _totalactivitykaryawan;

  Future<void> getTotalActivityKaryawan({
    required String id,
    required String tokenss,
  }) async {
    try {
      _totalactivitykaryawan =
          await service.getTotalActivityKaryawan(id: id, tokenss: tokenss);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  MonitoringPresensiSiswaModel? _siswa;
  MonitoringPresensiSiswaModel? get siswa => _siswa;

  Future<void> getPresensiswa({
    required String id,
    required String tokenss,
  }) async {
    try {
      _siswa = await service.getPresensiSiswa(id: id, tokenss: tokenss);
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  MonitoringPresensiKaryawanModel? _karyawan;
  MonitoringPresensiKaryawanModel? get karyawan => _karyawan;

  Future<void> getPresenKaryawan({
    required String id,
    required String tokenss,
  }) async {
    try {
      _karyawan = await service.getPresensiKaryawan(id: id, tokenss: tokenss);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<Kelas> _kelasList = [];

  List<Kelas> get kelasList => _kelasList;

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
      // Handle the error
    }
  }

  Future<void> clearState() async {
    _getUserGrAll = [];
    _getUserGr = [];
    _getUserKrAll = [];
    _getUserKr = [];
    _getUserXtAll = [];
    _getUserXt = [];
    _aktifitas = MainListAktifitasModel(guru: [], karyawan: [], extra: []);
    _groups = [];
    _monitoringKoneksi = MonitoringKoneksiPhone();
    _monitoringData = Monitoring30DayGrouped();
    _acguru = [];
    _ackaryawan = [];
    _totalactivityguru = [];
    _totalactivitykaryawan = [];
    _siswa = MonitoringPresensiSiswaModel();
    _karyawan = MonitoringPresensiKaryawanModel();
    _kelasList = [];
    notifyListeners();
  }
}
