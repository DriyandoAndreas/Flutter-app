import 'package:flutter/material.dart';
import 'package:app5/models/komunikasi_model.dart';
import 'package:app5/services/komunikasi_service.dart';

///******Gac komunikasi proivder */
class KomunikasiProvider with ChangeNotifier {
  KomunikasiService komunikasiService = KomunikasiService();
  int _limit = 10;
  bool hasMore = true;
  List<KomunikasiUmumModel> _listUmum = [];
  List<KomunikasiTahfidzModel> _listTahfidz = [];
  List<ListKomunikasiMapelModel> _listMapel = [];
  List<ListKomunikasiEkskulModel> _listEkskul = [];
  List<ListKomunikasiKelasModel> _listKelas = [];
  List<ListKomunikasiKelompokModel> _listKelompok = [];
  List<ListKomunikasiSiswaModel> _listSiswa = [];
  List<ListKomunikasiCommentModel> _listComment = [];
  List<ViewKomunikasiTahfidzModel> _viewTahfidz = [];
  List<KomunikasiUmumModel> get listUmum => _listUmum;
  List<KomunikasiTahfidzModel> get listTahfidz => _listTahfidz;
  List<ListKomunikasiMapelModel> get listMapel => _listMapel;
  List<ListKomunikasiEkskulModel> get listEkskul => _listEkskul;
  List<ListKomunikasiKelasModel> get listKelas => _listKelas;
  List<ListKomunikasiKelompokModel> get listKelompok => _listKelompok;
  List<ListKomunikasiSiswaModel> get listSiswa => _listSiswa;
  List<ListKomunikasiCommentModel> get listComment => _listComment;
  List<ViewKomunikasiTahfidzModel> get viewTahfidz => _viewTahfidz;

  late ViewKomunikasiTahfidzModel _viewData = ViewKomunikasiTahfidzModel();
  ViewKomunikasiTahfidzModel get viewData => _viewData;

  set viewData(ViewKomunikasiTahfidzModel viewData) {
    _viewData = viewData;
    notifyListeners();
  }

  Future<void> initListUmum(
      {required String id, required String tokenss}) async {
    try {
      await initInfinitListUmum(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> initListTahfidz(
      {required String id, required String tokenss}) async {
    try {
      await initInfinitListTahfidz(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> initListMapel(
      {required String id, required String tokenss}) async {
    try {
      await initInfinitListMapel(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> initListEkskul(
      {required String id, required String tokenss}) async {
    try {
      await initInfinitListEkskul(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> initListKelas(
      {required String id, required String tokenss}) async {
    try {
      await initInfinitListKelas(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> initListComment({
    required String id,
    required String tokenss,
    required String param2,
    required String param3,
  }) async {
    try {
      List<ListKomunikasiCommentModel> respon = await komunikasiService
          .getComment(id: id, tokenss: tokenss, param2: param2, param3: param3);
      _listComment = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> initViewTahfidz({
    required String id,
    required String tokenss,
    required String param2,
  }) async {
    try {
      List<ViewKomunikasiTahfidzModel> respon = await komunikasiService
          .getViewTahfidz(id: id, tokenss: tokenss, param2: param2);
      _viewTahfidz = respon;
      if (respon.isNotEmpty) {
        _viewData = respon.firstWhere(
          (element) => element.idTahfidz == param2,
        );
      }
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> initInfinitListUmum({
    required String id,
    required String tokenss,
  }) async {
    try {
      _limit += 10;
      List<KomunikasiUmumModel> respon = await komunikasiService.getList(
          id: id, tokenss: tokenss, limit: _limit);
      if (respon.length < _limit) {
        hasMore = false;
      }
      _listUmum = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> initInfinitListTahfidz({
    required String id,
    required String tokenss,
  }) async {
    try {
      _limit += 10;
      List<KomunikasiTahfidzModel> respon = await komunikasiService.getTahfidz(
          id: id, tokenss: tokenss, limit: _limit);
      if (respon.length < _limit) {
        hasMore = false;
      }
      _listTahfidz = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> initInfinitListMapel({
    required String id,
    required String tokenss,
  }) async {
    try {
      _limit += 10;
      List<ListKomunikasiMapelModel> respon = await komunikasiService.getMapel(
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

  Future<void> initInfinitListEkskul({
    required String id,
    required String tokenss,
  }) async {
    try {
      _limit += 10;
      List<ListKomunikasiEkskulModel> respon = await komunikasiService
          .getEkskul(id: id, tokenss: tokenss, limit: _limit);
      if (respon.length < _limit) {
        hasMore = false;
      }
      _listEkskul = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> initInfinitListKelas({
    required String id,
    required String tokenss,
  }) async {
    try {
      _limit += 10;
      List<ListKomunikasiKelasModel> respon = await komunikasiService.getKelas(
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

  Future<void> initInfinitListKelompok({
    required String id,
    required String tokenss,
  }) async {
    try {
      _limit += 10;
      List<ListKomunikasiKelompokModel> respon =
          await komunikasiService.getKelompok(id: id, tokenss: tokenss);
      if (respon.length < _limit) {
        hasMore = false;
      }
      _listKelompok = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> initInfinitListSiswa(
      {required String id,
      required String tokenss,
      required String kodeKelas}) async {
    try {
      _limit += 10;
      List<ListKomunikasiSiswaModel> respon = await komunikasiService.getSiswa(
          id: id, tokenss: tokenss, kodeKelas: kodeKelas);
      if (respon.length < _limit) {
        hasMore = false;
      }
      _listSiswa = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> refreshListUmum(
      {required String id, required String tokenss}) async {
    try {
      _listUmum = [];
      hasMore = true;
      await initListUmum(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> refreshListTahfidz(
      {required String id, required String tokenss}) async {
    try {
      _listTahfidz = [];
      hasMore = true;
      await initListTahfidz(id: id, tokenss: tokenss);
    } catch (e) {
      return;
    }
  }

  Future<void> refreshViewTahfidz(
      {required String id,
      required String tokenss,
      required String param2}) async {
    try {
      _viewTahfidz = [];
      hasMore = true;
      await initViewTahfidz(id: id, tokenss: tokenss, param2: param2);
    } catch (e) {
      return;
    }
  }

  Future<void> clearState() async {
    _listUmum = [];
    _listTahfidz = [];
    _listMapel = [];
    _listEkskul = [];
    _listKelas = [];
    _listKelompok = [];
    _listSiswa = [];
    _listComment = [];
    _viewTahfidz = [];
    notifyListeners();
  }
}

//////////////////////////////////
///********Sat komunikasi provider */
class SatKomunikasiProvider with ChangeNotifier {
  SatKomunikasiService service = SatKomunikasiService();
  List<SatKomunikasiModel> _listUmum = [];
  List<SatKomunikasiModel> get listUmum => _listUmum;

  Future<void> getListUmum({
    required String id,
    required String tokenss,
  }) async {
    try {
      List<SatKomunikasiModel> respon =
          await service.getList(id: id, tokenss: tokenss);
      _listUmum = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<SatKomunikasiTahfidzModel> _listTahfidz = [];
  List<SatKomunikasiTahfidzModel> get listTahfidz => _listTahfidz;
  Future<void> getListTahfidz({
    required String id,
    required String tokenss,
  }) async {
    try {
      List<SatKomunikasiTahfidzModel> respon =
          await service.getListTahfidz(id: id, tokenss: tokenss);
      _listTahfidz = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<ViewKomunikasiUmumModel> _viewUmum = [];
  List<ViewKomunikasiUmumModel> get viewUmum => _viewUmum;
  Future<void> getViewUmum({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    try {
      List<ViewKomunikasiUmumModel> respon =
          await service.getViewUmum(id: id, tokenss: tokenss, param: param);
      _viewUmum = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<SatViewKomunikasiTahfidzModel> _viewTahfidz = [];
  List<SatViewKomunikasiTahfidzModel> get viewTahfidz => _viewTahfidz;
  Future<void> getViewTahfidz({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    try {
      List<SatViewKomunikasiTahfidzModel> respon =
          await service.getViewTahfidz(id: id, tokenss: tokenss, param: param);
      _viewTahfidz = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<SatKomentarModel> _komentarUmum = [];
  List<SatKomentarModel> get komentarUmum => _komentarUmum;
  Future<void> getListKomentarUmum({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    try {
      List<SatKomentarModel> respon = await service.getListKomentarUmum(
          id: id, tokenss: tokenss, param: param);
      _komentarUmum = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<SatKomentarModel> _komentarTahfidz = [];
  List<SatKomentarModel> get komentarTahfidz => _komentarTahfidz;
  Future<void> getListKomentarTahfidz({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    try {
      List<SatKomentarModel> respon = await service.getListKomentarTahfidz(
          id: id, tokenss: tokenss, param: param);
      _komentarTahfidz = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> clearState() async {
    _listUmum = [];
    _listTahfidz = [];
    _viewUmum = [];
    _viewTahfidz = [];
    _komentarUmum = [];
    _komentarTahfidz = [];
    notifyListeners();
  }
}
