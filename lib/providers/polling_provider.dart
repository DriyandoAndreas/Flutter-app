import 'package:flutter/material.dart';
import 'package:app5/models/polling_model.dart';
import 'package:app5/services/polling_service.dart';

///***Gac polling provider */
class PollingProvider with ChangeNotifier {
  PollingService service = PollingService();
  List<ListPollingModel> _list = [];
  List<ListPollingModel> get list => _list;

  Future<void> getList({
    required String id,
    required String tokenss,
  }) async {
    try {
      List<ListPollingModel> respon =
          await service.getList(id: id, tokenss: tokenss);
      _list = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  List<TextEditingController> controllers = [];
  List<ViewPollingJawabanModel> _getJawaban = [];
  List<ViewPollingJawabanModel> get getJawaban => _getJawaban;

  Future<void> getJawabanPolling({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    List<ViewPollingJawabanModel> respon =
        await service.getPilihanJawaban(id: id, tokenss: tokenss, param: param);
    _getJawaban = respon;
    controllers = List.generate(_getJawaban.length,
        (index) => TextEditingController(text: _getJawaban[index].jawaban));

    notifyListeners();
  }

  void disposeControllers() {
    for (var controller in controllers) {
      controller.dispose();
    }
    controllers.clear();
  }

  List<ViewPollingModel> _getPolling = [];
  List<ViewPollingModel> get getPoling => _getPolling;

  Future<void> getPolling({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    try {
      List<ViewPollingModel> respon =
          await service.getPolling(id: id, tokenss: tokenss, param: param);
      _getPolling = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  PollingPosertaModel _peserta = PollingPosertaModel();
  PollingPosertaModel get peserta => _peserta;

  Future<void> getPeserta({
    required String id,
    required String tokenss,
  }) async {
    try {
      PollingPosertaModel respon =
          await service.getPeserta(id: id, tokenss: tokenss);
      _peserta = respon;
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}

///*************Sat polling provider */
class SatPollingProvider with ChangeNotifier {
  SatPollingService service = SatPollingService();
  List<SatListPollingModel> _list = [];
  List<SatListPollingModel> get list => _list;

  Future<void> getList({
    required String id,
    required String tokenss,
  }) async {
    List<SatListPollingModel> respon =
        await service.getList(id: id, tokenss: tokenss);
    _list = respon;
    notifyListeners();
  }

  List<TextEditingController> controllers = [];
  List<SatViewPollingJawabanModel> _getJawaban = [];
  List<SatViewPollingJawabanModel> get getJawaban => _getJawaban;

  Future<void> getJawabanPolling({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    List<SatViewPollingJawabanModel> respon =
        await service.getPilihanJawaban(id: id, tokenss: tokenss, param: param);
    _getJawaban = respon;

    notifyListeners();
  }

  List<SatViewPollingModel> _getPolling = [];
  List<SatViewPollingModel> get getPoling => _getPolling;

  Future<void> getPolling({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    List<SatViewPollingModel> respon =
        await service.getPolling(id: id, tokenss: tokenss, param: param);
    _getPolling = respon;
    notifyListeners();
  }
}
