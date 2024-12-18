import 'package:flutter/material.dart';
import 'package:app5/models/playlist_mengajar_model.dart';
import 'package:app5/services/playlist_mengajar_service.dart';

class PlaylistMengajarProviderToday with ChangeNotifier {
  PlaylistMengajarService service = PlaylistMengajarService();

  List<TodayTimeLine> _timeline = [];
  List<TodayTimeLine> get timeline => _timeline;
  Future<void> getTodayTimeLine({
    required String id,
    required String tokenss,
    required int interval,
  }) async {
    try {
      var respon = await service.getTodayTimeLine(
          id: id, tokenss: tokenss, interval: interval);
      _timeline = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> clearState() async {
    _timeline = [];
    notifyListeners();
  }
}
