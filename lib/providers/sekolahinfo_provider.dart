import 'package:flutter/material.dart';
import 'package:app5/models/sekolahinfo_model.dart';
import 'package:app5/services/sekolahinfo_service.dart';

class SekolahInfoProvider with ChangeNotifier {
  SekolahInfoService service = SekolahInfoService();
  SekolahInfoTop _infotop = SekolahInfoTop();
  SekolahInfoTop get infotop => _infotop;

  Future<void> getInfoTop({required token, required npsn}) async {
    try {
      _infotop = await service.infoTop(token: token, npsn: npsn);
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}
