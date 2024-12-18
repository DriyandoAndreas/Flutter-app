import 'package:flutter/material.dart';
import 'package:app5/models/keuangan_model.dart';
import 'package:app5/services/keuangan_service.dart';

class CardTagihanProvider with ChangeNotifier {
  KeuanganService service = KeuanganService();
  CardTagihanModel _tagihan = CardTagihanModel();
  CardTagihanModel get tagihan => _tagihan;

  Future<void> getTagihan({
    required String id,
    required String tokenss,
  }) async {
    try {
      _tagihan = await service.getTagihan(id: id, tokenss: tokenss);
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}
