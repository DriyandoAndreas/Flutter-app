import 'package:flutter/material.dart';
import 'package:app5/models/keuangan_model.dart';
import 'package:app5/services/keuangan_service.dart';

class SatKeuanganWidgetProvider with ChangeNotifier {
  final KeuanganService keuangService = KeuanganService();
  List<ListKeuanganTransaksiModel> _listTrx = [];
  List<ListKeuanganTransaksiModel> get listTrx => _listTrx;
  List<KeuangaKwintansiModel> _listDetialKwitansi = [];
  List<KeuangaKwintansiModel> get listDetialKwitansi => _listDetialKwitansi;
  List<DataKwitansiModel> _listInnerKwtbulanan = [];
  List<DataKwitansiModel> get listInnerKwtbulanan => _listInnerKwtbulanan;
  List<DataKwitansiLainModel> _listInnerKwtlain = [];
  List<DataKwitansiLainModel> get listInnerKwtlain => _listInnerKwtlain;
  Future<void> getDetialPembayaran({
    required String id,
    required String tokenss,
  }) async {
    try {
      List<ListKeuanganTransaksiModel> respon =
          await keuangService.getListTransaksi(id: id, tokenss: tokenss);
      _listTrx = respon;
      if (respon.isNotEmpty) {
        var param = respon.first.trxid;
        List<KeuangaKwintansiModel> responkwt = await keuangService.getKwitansi(
            id: id, tokenss: tokenss, param: param!);
        _listDetialKwitansi = responkwt;
        MainDataKwitansiModel responinnerdatakwt = await keuangService
            .getDataTransaksi(id: id, tokenss: tokenss, param: param);
        _listInnerKwtbulanan = responinnerdatakwt.listDataKwitansiBulanan
            as List<DataKwitansiModel>;
        _listInnerKwtlain = responinnerdatakwt.listDataKwitansiLain
            as List<DataKwitansiLainModel>;
        notifyListeners();
      }
    } catch (e) {
      return;
    }
  }

  Future<void> clearState() async {
    _listTrx = [];
    _listDetialKwitansi = [];
    _listInnerKwtbulanan = [];
    _listInnerKwtlain = [];
    notifyListeners();
  }
}
