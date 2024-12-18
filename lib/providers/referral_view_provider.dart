import 'package:flutter/material.dart';
import 'package:app5/models/referral_model.dart';
import 'package:app5/services/referral_service.dart';

class ReferralViewProvider with ChangeNotifier {
  ReferralService service = ReferralService();
  List<ReferralSekolahAktifModel> _yreg = [];
  List<ReferralSekolahAktifModel> get yreg => _yreg;
  List<ReferralSekolahBelumAktifModel> _nreg = [];
  List<ReferralSekolahBelumAktifModel> get nreg => _nreg;

  Future<void> getSekolahAktif(
      {required String id, required String tokenss}) async {
    try {
      _yreg = await service.getSekolahAktif(id: id, tokenss: tokenss);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> getSekolahBelumAktif(
      {required String id, required String tokenss}) async {
    try {
      _nreg = await service.getSekolahBelumAktif(id: id, tokenss: tokenss);
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}
