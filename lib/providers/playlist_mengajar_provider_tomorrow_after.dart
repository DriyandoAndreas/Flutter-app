import 'package:flutter/material.dart';
import 'package:app5/models/playlist_mengajar_model.dart';
import 'package:app5/services/playlist_mengajar_service.dart';

class PlaylistMengajarProviderTomorrowAfter with ChangeNotifier {
  PlaylistMengajarService service = PlaylistMengajarService();

  List<TommorowAfterTimeLine> _tommorrowaftertimeline = [];
  List<TommorowAfterTimeLine> get tommorrowaftertimeline =>
      _tommorrowaftertimeline;
  Future<void> getTommorroAfterTimeLine({
    required String id,
    required String tokenss,
    required int interval,
  }) async {
    try {
      var respon = await service.getTommorrowAfterTimeLine(
          id: id, tokenss: tokenss, interval: interval);
      _tommorrowaftertimeline = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> clearState() async {
    _tommorrowaftertimeline = [];
    notifyListeners();
  }
}
