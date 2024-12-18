import 'package:flutter/material.dart';
import 'package:app5/models/keuangan_model.dart';
import 'package:app5/services/keuangan_service.dart';

class KeuanganProvider with ChangeNotifier {
  KeuanganService keuangService = KeuanganService();
  List<ListKeuanganTagihanModel> _listTgh = [];
  List<ListKeuanganTagihanModel> get listTgh => _listTgh;

  Future<void> getListTagihan({
    required String id,
    required String tokenss,
  }) async {
    try {
      List<ListKeuanganTagihanModel> respon =
          await keuangService.getListTagihan(id: id, tokenss: tokenss);
      _listTgh = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<ListKeuanganTransaksiModel> _listTrx = [];
  List<ListKeuanganTransaksiModel> get listTrx => _listTrx;
  Future<void> getListTransaksi({
    required String id,
    required String tokenss,
  }) async {
    try {
      List<ListKeuanganTransaksiModel> respon =
          await keuangService.getListTransaksi(id: id, tokenss: tokenss);
      _listTrx = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<InvoiceBulanan> _listBulanan = [];
  List<InvoiceBulanan> _listTerbatas = [];
  List<InvoiceBulanan> _listBebas = [];
  List<PaymentViaModel> _listPaymentVias = [];

  List<InvoiceBulanan> get listBulanan => _listBulanan;
  List<InvoiceBulanan> get listTerbatas => _listTerbatas;
  List<InvoiceBulanan> get listBebas => _listBebas;
  List<PaymentViaModel> get listPaymentVias => _listPaymentVias;

  Future<void> getFormDetail({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    try {
      DetailKeuanganModel respon = await keuangService.getInvoice(
          id: id, tokenss: tokenss, param: param);
      if (respon.dataBulanan == null) {
        _listBulanan = [];
      } else {
        _listBulanan = respon.dataBulanan as List<InvoiceBulanan>;
      }
      DetailKeuanganModel responterbatas = await keuangService.getInvoice(
          id: id, tokenss: tokenss, param: param);
      if (responterbatas.dataTerbatas == null) {
        _listTerbatas = [];
      } else {
        _listTerbatas = responterbatas.dataTerbatas as List<InvoiceBulanan>;
      }
      DetailKeuanganModel responbebas = await keuangService.getInvoice(
          id: id, tokenss: tokenss, param: param);
      if (responbebas.dataBebas == null) {
        _listBebas = [];
      } else {
        _listBebas = responbebas.dataBebas as List<InvoiceBulanan>;
      }
      DetailKeuanganModel responpaymentvias = await keuangService.getInvoice(
          id: id, tokenss: tokenss, param: param);
      _listPaymentVias = responpaymentvias.paymentvias as List<PaymentViaModel>;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<KeuangaKwintansiModel> _listKwitansi = [];
  List<DataKwitansiModel> _listInnerDataKwitansibulanan = [];
  List<DataKwitansiLainModel> _listInnerDataKwitansilain = [];
  List<KeuangaKwintansiModel> get listKwitansi => _listKwitansi;
  List<DataKwitansiModel> get listInnerDataKwitansibulanan =>
      _listInnerDataKwitansibulanan;
  List<DataKwitansiLainModel> get listInnerDataKwitansilain =>
      _listInnerDataKwitansilain;
  Future<void> getKwitansi(
      {required String id,
      required String tokenss,
      required String param}) async {
    try {
      List<KeuangaKwintansiModel> respon = await keuangService.getKwitansi(
          id: id, tokenss: tokenss, param: param);
      MainDataKwitansiModel respondata = await keuangService.getDataTransaksi(
          id: id, tokenss: tokenss, param: param);
      _listInnerDataKwitansibulanan =
          respondata.listDataKwitansiBulanan as List<DataKwitansiModel>;
      _listInnerDataKwitansilain =
          respondata.listDataKwitansiLain as List<DataKwitansiLainModel>;
      _listKwitansi = respon;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> clearState() async {
    _listTgh = [];
    _listTrx = [];
    _listBulanan = [];
    _listTerbatas = [];
    _listBebas = [];
    _listPaymentVias = [];
    _listKwitansi = [];
    _listInnerDataKwitansibulanan = [];
    _listInnerDataKwitansilain = [];
    notifyListeners();
  }
}
