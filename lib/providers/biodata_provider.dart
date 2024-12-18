import 'package:flutter/material.dart';
import 'package:app5/models/biodata_model.dart';
import 'package:app5/services/biodata_service.dart';

class BoidataProvider with ChangeNotifier {
  BiodataService service = BiodataService();

  BiodataGacModel? _biodatagac;
  BiodataGacModel? get biodatagac => _biodatagac;

  Future<void> getBioGac({required String id, required String tokenss}) async {
    try {
      _biodatagac = await service.getBioGac(id: id, tokenss: tokenss);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  BiodataSatModel? _biodatasat;
  BiodataSatModel? get biodatasat => _biodatasat;

  Future<void> getBioSat({required String id, required String tokenss}) async {
    try {
      _biodatasat = await service.getBioSat(id: id, tokenss: tokenss);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> clearState() async {
    _biodatagac = null;
    _biodatasat = null;
    notifyListeners();
  }
}
