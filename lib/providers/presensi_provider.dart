import 'package:flutter/material.dart';
import 'package:sisko_v5/models/presensi_model.dart';
import 'package:sisko_v5/services/presensi_service.dart';

class PresensiProvider with ChangeNotifier {
  final presensiServie = PresensiService();

  List<PresensiModel> _list = [];

  List<PresensiModel> get list => _list;

  Future<void> initList({required String id, required String tokenss}) async {
    try {
      List<PresensiModel> respon =
          await presensiServie.getList(id: id, tokenss: tokenss);
      _list = respon;
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> refresh({required String id, required String tokenss}) async {
    try {
      _list = [];
      await initList(id: id, tokenss: tokenss);
    } catch (e) {
      throw Exception(e);
    }
  }
}
