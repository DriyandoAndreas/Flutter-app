import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app5/models/presensi_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

////////////////////////////////////////////
///***********Gac Presensi Service */
class PresensiService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<PresensiModel>> getList({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/presensi/lists.php');
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
        List<PresensiModel> getKelas =
            responseData.map((data) => PresensiModel.fromJson(data)).toList();
        return getKelas;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<PresensiKelasOpenModel>> getKelasOpen({
    required String id,
    required String tokenss,
    required String kodeKelas,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/presensi/lists-kelas-open.php?kode_kelas=$kodeKelas');
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
        List<PresensiKelasOpenModel> getKelasOpen = responseData
            .map((data) => PresensiKelasOpenModel.fromJson(data))
            .toList();
        return getKelasOpen;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> addPresensi({
    required String id,
    required String tokenss,
    required String action,
    required String tanggal,
    required List<String> nis,
    required List<String> jenisAbsen,
    required String mode,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/presensi/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'tgl': tanggal,
    };
    for (int i = 0; i < nis.length; i++) {
      body['absen[${nis[i]}]'] = jenisAbsen[i];
    }
    body['mode'] = mode;
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }
}
////////////////////////////////////
///********Sat Presensi Service */

class SatPresensiService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];

  Future<Map<String, dynamic>> getPresensiBulanan({
    required String id,
    required String tokenss,
    required String kode,
    required String tglabsensi,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/presensi/list-bulanan.php?kode=$kode&tgl_absensi=$tglabsensi');
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
        final Map<String, dynamic> presensidata = responseData['presensi'];
        final Map<String, dynamic> presensi = presensidata['presensi'];
        return presensi;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> getPresensiSum({
    required String id,
    required String tokenss,
    required String kode,
    required String tglabsensi,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/presensi/list-bulanan.php?kode=$kode&tgl_absensi=$tglabsensi');
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
        final Map<String, dynamic> presensidata = responseData['presensi'];
        final Map<String, dynamic> presensisumdata =
            presensidata['presensi_sum'];
        return presensisumdata;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return {};
    }
  }

  Future<List<SatPresensiHistoryModel>> getHistory({
    required String id,
    required String tokenss,
    required String kode,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/presensi/list-history.php?kode=$kode');
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
        final Map<String, dynamic> historyData = responseData['history'];
        final List<dynamic> datahistory = historyData.values.first;
        List<SatPresensiHistoryModel> listhistory = datahistory.map((e) {
          return SatPresensiHistoryModel.fromJson(e);
        }).toList();

        return listhistory;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> addFormIjin({
    required String id,
    required String tokenss,
    required String kode,
    required List<String> tgl,
    required String keterangan,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul_sat/presensi/exe.php');
    String tanggalIjinString = tgl.join(',');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': 'edit',
      '_kode': kode,
      'jenis_absen': 'I',
      'keterangan': keterangan,
      'tanggal_ijin': tanggalIjinString,
    };

    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }

  Future<void> addFormSakit({
    required String id,
    required String tokenss,
    required String kode,
    required List<String> tgl,
    required String keterangan,
    required String filename,
    required String type,
    required String base64flutter,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul_sat/presensi/exe.php');
    String tanggalIjinString = tgl.join(',');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': 'edit',
      '_kode': kode,
      'jenis_absen': 'S',
      'keterangan': keterangan,
      'tanggal_sakit': tanggalIjinString,
      'filename_flutter': filename,
      'type_flutter': type,
      'base64_flutter': base64flutter,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }
}
