import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sisko_v5/models/presensi_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      throw Exception(e);
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
      throw Exception(e);
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
      throw Exception(e);
    }
  }
}
