import 'package:flutter/material.dart';
import 'package:app5/models/school_landingpage.dart';
import 'package:app5/services/school_landingpage_service.dart';

class SchoolLandingpageProvider with ChangeNotifier {
  SchoolLandingpageService service = SchoolLandingpageService();
  List<SchoolLandingpageModel> _data = [];
  List<SchoolLandingpageModel> get data => _data;

  Future<void> getSchoolHeader({required String npsn}) async {
    try {
      _data = await service.getSchoolHeader(npsn: npsn);
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}
