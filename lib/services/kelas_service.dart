import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sisko_v5/models/kelas_model.dart';

class KelasService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<KelasModel>> getKelas({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url =
        Uri.parse('$apiUrl/client_api/modul/kelas/lists.php?limit=$limit');
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
        List<KelasModel> getKelas =
            responseData.map((data) => KelasModel.fromJson(data)).toList();
        return getKelas;
      } else {
        throw Exception(
            'Failed to get kelas list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<KelasOpenModel>> getListKelas({
    required String id,
    required String tokenss,
    required String kodeKelas,
    required int limit,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/kelas/lists-kelas-open.php?kode_kelas=$kodeKelas&limit=$limit');
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
        List<KelasOpenModel> getList =
            responseData.map((data) => KelasOpenModel.fromJson(data)).toList();
        return getList;
      } else {
        throw Exception(
            'Failed to get kelas list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addGroup({
    required String id,
    required String tokenss,
    required String kodeKelas,
    required String kodePegawai,
    required String action,
    required String linkGroup,
  }) async {
    try {
      var url = Uri.parse('$apiUrl/client_api/modul/kelas/exe.php');
      var headers = {
        'ID': id,
        'tokenss': tokenss,
      };
      var body = {
        'kode_kelas': kodeKelas,
        'kode_pegawai': kodePegawai,
        'action': action,
        'wagroup': linkGroup,
      };
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      throw Exception(e);
    }
  }
}
