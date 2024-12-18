import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app5/models/polling_model.dart';

/////////////////////////////////
///**Gac polling service */
class PollingService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<ListPollingModel>> getList({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/polling/list.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    try {
      var response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['datas'];
        List<ListPollingModel> getList = responseData
            .map((data) => ListPollingModel.fromJson(data))
            .toList();
        return getList;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ViewPollingJawabanModel>> getPilihanJawaban({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    var url =
        Uri.parse('$apiUrl/client_api/modul/polling/view.php?param=$param');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    try {
      var response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(response.body)['data'];
        final List<dynamic> datas = responseData['pilihan'];
        List<ViewPollingJawabanModel> getJawaban = datas
            .map((data) => ViewPollingJawabanModel.fromJson(data))
            .toList();
        return getJawaban;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<ViewPollingModel>> getPolling({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    var url =
        Uri.parse('$apiUrl/client_api/modul/polling/view.php?param=$param');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    try {
      var response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(response.body)['data'];
        final List<dynamic> datas = responseData['polling'];
        List<ViewPollingModel> getPolling =
            datas.map((data) => ViewPollingModel.fromJson(data)).toList();
        return getPolling;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> addJawaban({
    required String id,
    required String tokenss,
    required String action,
    required String kodepolling,
    required String kdpollpeserta,
    required String kdjawaban,
    required String idpeserta,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/polling/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'kd_polling': kodepolling,
      'kd_pol_peserta': kdpollpeserta,
      'kd_jawaban': kdjawaban,
      'id_peserta': idpeserta,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }

  Future<PollingPosertaModel> getPeserta(
      {required String id, required String tokenss}) async {
    var url = Uri.parse('$apiUrl/client_api/modul/polling/form.php?');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    try {
      var response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(response.body)['data'];
        PollingPosertaModel datapeserta =
            PollingPosertaModel.fromJson(responseData);
        return datapeserta;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return PollingPosertaModel();
    }
  }

  Future<void> addPolling({
    required String id,
    required String tokenss,
    required String action,
    required String namapolling,
    required String tanggalmulai,
    required String tanggalselesai,
    required List<String> peserta,
    required String pertanyaan,
    required List<String> jawaban,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/polling/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    var pesertaString =
        peserta.map((p) => 'peserta[]=${Uri.encodeComponent(p)}').join('&');
    var jawabanString =
        jawaban.map((j) => 'jawaban[]=${Uri.encodeComponent(j)}').join('&');

    var bodyString = [
      'action=${Uri.encodeComponent(action)}',
      'nama_polling=${Uri.encodeComponent(namapolling)}',
      'tgl_mulai=${Uri.encodeComponent(tanggalmulai)}',
      'tgl_selesai=${Uri.encodeComponent(tanggalselesai)}',
      'pertanyaan=${Uri.encodeComponent(pertanyaan)}',
      pesertaString,
      jawabanString,
    ].join('&');
    try {
      await http.post(url, headers: headers, body: bodyString);
    } catch (e) {
      return;
    }
  }

  Future<void> editPolling({
    required String id,
    required String tokenss,
    required String action,
    required String kodepolling,
    required String namapolling,
    required String tanggalmulai,
    required String tanggalselesai,
    required List<String> peserta,
    required String pertanyaan,
    required List<String> jawaban,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/polling/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var pesertaString =
        peserta.map((p) => 'peserta[]=${Uri.encodeComponent(p)}').join('&');
    var jawabanString =
        jawaban.map((j) => 'jawaban[]=${Uri.encodeComponent(j)}').join('&');

    var bodyString = [
      'action=${Uri.encodeComponent(action)}',
      'kd_polling=${Uri.encodeComponent(kodepolling)}',
      'nama_polling=${Uri.encodeComponent(namapolling)}',
      'tgl_mulai=${Uri.encodeComponent(tanggalmulai)}',
      'tgl_selesai=${Uri.encodeComponent(tanggalselesai)}',
      'pertanyaan=${Uri.encodeComponent(pertanyaan)}',
      pesertaString,
      jawabanString,
    ].join('&');
    try {
      await http.post(url, headers: headers, body: bodyString);
    } catch (e) {
      return;
    }
  }

  Future<void> deletePolling({
    required String id,
    required String tokenss,
    required String action,
    required String idc,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/polling/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'idc': idc,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }
}

//////////////////////////////////////////////////
///**Sat polling service */
class SatPollingService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<SatListPollingModel>> getList({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul_sat/polling/list.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    try {
      var response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['datas'];
        List<SatListPollingModel> getList = responseData
            .map((data) => SatListPollingModel.fromJson(data))
            .toList();
        return getList;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<SatViewPollingJawabanModel>> getPilihanJawaban({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    var url =
        Uri.parse('$apiUrl/client_api/modul_sat/polling/view.php?param=$param');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    try {
      var response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(response.body)['data'];
        final List<dynamic> datas = responseData['pilihan_jawaban'];
        List<SatViewPollingJawabanModel> getJawaban = datas
            .map((data) => SatViewPollingJawabanModel.fromJson(data))
            .toList();
        return getJawaban;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<SatViewPollingModel>> getPolling({
    required String id,
    required String tokenss,
    required String param,
  }) async {
    var url =
        Uri.parse('$apiUrl/client_api/modul_sat/polling/view.php?param=$param');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    try {
      var response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(response.body)['data'];
        final List<dynamic> datas = responseData['poling'];
        List<SatViewPollingModel> getPolling =
            datas.map((data) => SatViewPollingModel.fromJson(data)).toList();
        return getPolling;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> addJawaban({
    required String id,
    required String tokenss,
    required String action,
    required String kodepolling,
    required String kdpollpeserta,
    required String kdjawaban,
    required String idpeserta,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul_sat/polling/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'kd_polling': kodepolling,
      'kd_pol_peserta': kdpollpeserta,
      'kd_jawaban': kdjawaban,
      'id_peserta': idpeserta,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }
}
