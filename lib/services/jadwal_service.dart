import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:sisko_v5/models/jadwal_model.dart';

class JadwalService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<JadwalModel>> getListMapel({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/jadwal/lists-mapel.php?limit=$limit');
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
        List<JadwalModel> getKelas =
            responseData.map((data) => JadwalModel.fromJson(data)).toList();
        return getKelas;
      } else {
        throw Exception(
            'Failed to get  list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<JadwalKelaslModel>> getListKelas({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/jadwal/lists-kelas.php?limit=$limit');
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
        List<JadwalKelaslModel> getKelas = responseData
            .map((data) => JadwalKelaslModel.fromJson(data))
            .toList();
        return getKelas;
      } else {
        throw Exception(
            'Failed to get  list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<DetailJadwalHarian>> getListJadwalHarian({
    required String id,
    required String tokenss,
    required String param3,
  }) async {
    var url = Uri.parse(
      '$apiUrl/client_api/modul/jadwal/lists-show-jadwal-harian.php?param3=$param3',
    );
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
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        final Map<String, dynamic> data = responseData['data'];
        final Map<String, dynamic> detailData = data['Detail'];

        List<DetailJadwalHarian> getKelas = [];

        detailData.forEach((key, value) {
          final Map<String, dynamic> detailValues =
              value as Map<String, dynamic>;
          getKelas.addAll(detailValues.entries.map((entry) {
            final value = entry.value as Map<String, dynamic>;
            return DetailJadwalHarian.fromJson(value);
          }));
        });

        return getKelas;
      } else {
        throw Exception(
          'Failed to get list. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ListMengajarModel>> getListMengajar({
    required String id,
    required String tokenss,
    required String param3,
  }) async {
    var url = Uri.parse(
      '$apiUrl/client_api/modul/jadwal/lists-show-jadwal-harian.php?param3=$param3',
    );
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
        List data = json.decode(response.body)['data']['listMengajar'];
        return data.map((item) => ListMengajarModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load listMengajar');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addMengajar({
    required String id,
    required String tokenss,
    required String action,
    required String tab,
    required String kodePelajaran,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/jadwal/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'tab': tab,
      'kode_pljrn': kodePelajaran,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      throw Exception('Error, Gagal menambah data : $e');
    }
  }

  Future<void> addJadwal({
    required String id,
    required String tokenss,
    required String action,
    required String jdwl,
    required String kodeMengajar,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/jadwal/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };

    var body = {
      'action': action,
      'jdwl[$jdwl]': kodeMengajar,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      throw Exception('Error, Gagal menambah data : $e');
    }
  }

  Future<void> deleteMengajar({
    required String id,
    required String tokenss,
    required String action,
    required String tab,
    required String kodePelajaran,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/jadwal/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'tab': tab,
      'kode_pljrn': kodePelajaran,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      throw Exception('Error, Gagal menghapus data : $e');
    }
  }
}
