import 'package:flutter/material.dart';
import 'package:app5/models/nilai_model.dart';
import 'package:app5/services/nilai_service.dart';

/////////////////////////////////////////
///********Gac Nilai Provider */
class NilaiProvider with ChangeNotifier {
  NilaiService nilaiService = NilaiService();
  bool hasMore = true;
  int _limit = 10;
  List<NilaiKelasModel> _listKelas = [];
  List<ListNilaiMapelModel> _listMapel = [];
  List<NilaiJenisModel> _listJenisNilai = [];
  List<ListShowNilaiModel> _listShowNilai = [];

  List<NilaiKelasModel> get listKelas => _listKelas;
  List<ListNilaiMapelModel> get listMapel => _listMapel;
  List<NilaiJenisModel> get listJenisNilai => _listJenisNilai;
  List<ListShowNilaiModel> get listShowNilai => _listShowNilai;

  Future<void> initKelas({
    required String id,
    required String tokenss,
  }) async {
    try {
      await infinitKelas(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> initMapel({
    required String id,
    required String tokenss,
    required String kodeKelas,
  }) async {
    try {
      await infinitMapel(id: id, tokenss: tokenss, kodeKelas: kodeKelas);
    } catch (e) {
      return;
    }
  }

  Future<void> initJenisNilai({
    required String id,
    required String tokenss,
  }) async {
    try {
      await infinitJenisNilai(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> initShowNilai({
    required String id,
    required String tokenss,
    required String kodeKelas,
    required String jp,
    required String kodeMengajar,
  }) async {
    try {
      await showAllNilai(
        id: id,
        tokenss: tokenss,
        kodeKelas: kodeKelas,
        jp: jp,
        kodeMengajar: kodeMengajar,
      );
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
      List<NilaiKelasModel> respon =
          await nilaiService.getList(id: id, tokenss: tokenss);
      if (respon.length < _limit) {
        hasMore = true;
      }
      _listKelas = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> infinitMapel({
    required String id,
    required String tokenss,
    required String kodeKelas,
  }) async {
    try {
      _limit += 10;
      List<ListNilaiMapelModel> respon = await nilaiService.getListMapel(
          id: id, tokenss: tokenss, kodeKelas: kodeKelas);
      if (respon.length < _limit) {
        hasMore = true;
      }
      _listMapel = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> infinitJenisNilai({
    required String id,
    required String tokenss,
  }) async {
    try {
      List<NilaiJenisModel> respon =
          await nilaiService.getJenisNilai(id: id, tokenss: tokenss);
      _listJenisNilai = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> showAllNilai({
    required String id,
    required String tokenss,
    required String kodeKelas,
    required String jp,
    required String kodeMengajar,
  }) async {
    try {
      List<ListShowNilaiModel> respon = await nilaiService.getShowNilai(
          id: id,
          tokenss: tokenss,
          jp: jp,
          kodeKelas: kodeKelas,
          kodeMengajar: kodeMengajar);
      _listShowNilai = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> refresh({required String id, required String tokenss}) async {
    _listKelas = [];
    hasMore = true;
    await infinitKelas(id: id, tokenss: tokenss);
  }

  Future<void> refreshNilai(
      {required String id,
      required String tokenss,
      required String kodeKelas,
      required String kodeMengajar,
      required String jp}) async {
    _listShowNilai = [];
    hasMore = true;
    await initShowNilai(
        id: id,
        tokenss: tokenss,
        kodeKelas: kodeKelas,
        kodeMengajar: kodeMengajar,
        jp: jp);
  }
}

////////////////////////////////////////////
///*******************Sat nilai proivder */
class SatNilaiProivder with ChangeNotifier {
  SatNilaiService service = SatNilaiService();
  //provider jenis penilaian
  List<SatNilaiMenuModel> _listmenu = [];
  List<SatNilaiMenuModel> get listmenu => _listmenu;
  Future<void> initMenuNilai(
      {required String id, required String tokenss}) async {
    try {
      SatMenuNilaiModel satMenuNilaiModel =
          await service.getMenuNilai(id: id, tokenss: tokenss);
      _listmenu = satMenuNilaiModel.listmenu!;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  //provider nilai
  List<SatNilaiModel> _listnilai = [];
  List<SatNilaiModel> get listnilai => _listnilai;
  Future<void> initShowNilai({
    required String id,
    required String tokenss,
    required String sem,
    required String tahunajaran,
    required String jenispenilaian,
    required String kodepenilaian,
  }) async {
    try {
      List<SatNilaiModel> satNilaiModel = await service.getNilai(
          id: id,
          tokenss: tokenss,
          semester: sem,
          tahunajaran: tahunajaran,
          jenispenilaian: jenispenilaian,
          kodepenilaian: kodepenilaian);
      _listnilai = satNilaiModel;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  //provider mapel
  List<SatNilaiMapelModel> _listmapel = [];
  List<SatNilaiMapelModel> get listmapel => _listmapel;

  Future<void> getMapel({
    required String id,
    required String tokenss,
    required String tahunajaran,
    required String semester,
  }) async {
    try {
      List<SatNilaiMapelModel> satNilaiMapelModel = await service.getMapel(
        id: id,
        tokenss: tokenss,
        tahunajaran: tahunajaran,
        semester: semester,
      );
      _listmapel = satNilaiMapelModel;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  //provider nilai ekskul
  List<SatNilaiEkskulModel> _nilaiEkskul = [];
  List<SatNilaiEkskulModel> get nilaiEkskul => _nilaiEkskul;

  Future<void> getNilaiEkskul({
    required String id,
    required String tokenss,
    required String tahunajaran,
    required String semester,
  }) async {
    try {
      List<SatNilaiEkskulModel> respon = await service.getEkskul(
          id: id,
          tokenss: tokenss,
          semester: semester,
          tahunajaran: tahunajaran);
      _nilaiEkskul = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}
