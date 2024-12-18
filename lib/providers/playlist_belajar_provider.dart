import 'package:flutter/material.dart';
import 'package:app5/models/playlist_belajar_model.dart';
import 'package:app5/services/playlist_belajar_service.dart';

class SatPlayListBelajarProvider with ChangeNotifier {
  SatPlayListBelajarService service = SatPlayListBelajarService();

  List<SatTodayTimeLine> _today = [];
  List<SatTodayTimeLine> get today => _today;

  Future<void> getTodayTimeLine({
    required String id,
    required String tokenss,
    required int interval,
  }) async {
    try {
      _today =
          await service.getToday(id: id, tokenss: tokenss, interval: interval);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<SatTommorowTimeLine> _tommorrowtimeline = [];
  List<SatTommorowTimeLine> get tommorrowtimeline => _tommorrowtimeline;
  Future<void> getTommorroTimeLine({
    required String id,
    required String tokenss,
    required int interval,
  }) async {
    try {
      _tommorrowtimeline = await service.getTommorrowTimeLine(
          id: id, tokenss: tokenss, interval: interval);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<SatTommorowAfterTimeLine> _tommorrowaftertimeline = [];
  List<SatTommorowAfterTimeLine> get tommorrowaftertimeline =>
      _tommorrowaftertimeline;
  Future<void> getTommorroAfterTimeLine({
    required String id,
    required String tokenss,
    required int interval,
  }) async {
    try {
      _tommorrowaftertimeline = await service.getTommorrowAfterTimeLine(
          id: id, tokenss: tokenss, interval: interval);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> refresh({
    required String id,
    required String tokenss,
  }) async {
    try {
      _today = [];
      _tommorrowtimeline = [];
      _tommorrowaftertimeline = [];
      await getTodayTimeLine(id: id, tokenss: tokenss, interval: 0);
      await getTommorroTimeLine(id: id, tokenss: tokenss, interval: 1);
      await getTommorroAfterTimeLine(id: id, tokenss: tokenss, interval: 2);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> watchplaylist({
    required String id,
    required String tokenss,
  }) async {
    try {
      //
      _today = await service.getToday(id: id, tokenss: tokenss, interval: 0);
      _tommorrowtimeline = await service.getTommorrowTimeLine(
          id: id, tokenss: tokenss, interval: 1);
      _tommorrowaftertimeline = await service.getTommorrowAfterTimeLine(
          id: id, tokenss: tokenss, interval: 2);
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}
