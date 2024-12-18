import 'package:flutter/material.dart';
import 'package:app5/models/playlist_mengajar_model.dart';
import 'package:app5/services/playlist_mengajar_service.dart';

class PlaylistMengajarProviderTomorrow with ChangeNotifier {
  PlaylistMengajarService service = PlaylistMengajarService();

  List<TommorowTimeLine> _tommorrowtimeline = [];
  List<TommorowTimeLine> get tommorrowtimeline => _tommorrowtimeline;
  Future<void> getTommorroTimeLine({
    required String id,
    required String tokenss,
    required int interval,
  }) async {
    try {
      var respon = await service.getTommorrowTimeLine(
          id: id, tokenss: tokenss, interval: interval);
      _tommorrowtimeline = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> clearState() async {
    _tommorrowtimeline = [];
    notifyListeners();
  }
}
