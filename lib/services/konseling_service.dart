import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app5/models/konseling_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/////////////////////////////////////////////
///**************Gac konseling service */
class KonselingService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<KonselingModel>> getList({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url =
        Uri.parse('$apiUrl/client_api/modul/konseling/lists.php?limit=$limit');
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
        List<KonselingModel> getKonseling =
            responseData.map((data) => KonselingModel.fromJson(data)).toList();
        return getKonseling;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ShowKelasModel>> showKelas({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/konseling/lists-show-kelas.php?limit=$limit');
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
        List<ShowKelasModel> showKelas =
            responseData.map((data) => ShowKelasModel.fromJson(data)).toList();
        return showKelas;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<PoinModel>> getPoin({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/konseling/poin.php');
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
        List<PoinModel> poin =
            responseData.map((data) => PoinModel.fromJson(data)).toList();
        return poin;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addKonseling({
    required String id,
    required String tokenss,
    required String action,
    required String jam,
    required String tanggal,
    required String nis,
    required String kasus,
    required String penanganan,
    required String nilai,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/konseling/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'tanggal': tanggal,
      'nis': nis,
      'jam': jam,
      'kasus': kasus,
      'penanganan': penanganan,
      'nilai': nilai,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      throw Exception('Error, Gagal menambahkan data: $e');
    }
  }

  Future<void> editKonseling({
    required String id,
    required String tokenss,
    required String action,
    required String jam,
    required String tanggal,
    required String nis,
    required String kasus,
    required String penanganan,
    required String nilai,
    required String kdKonseling,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/konseling/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'tanggal': tanggal,
      'nis': nis,
      'jam': jam,
      'kasus': kasus,
      'penanganan': penanganan,
      'nilai': nilai,
      'kd_konseling': kdKonseling,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      throw Exception('Error, Gagal edit data: $e');
    }
  }

  Future<void> deleteKonseling({
    required String id,
    required String tokenss,
    required String action,
    required String idc,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/konseling/exe.php');
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
      throw Exception('Error, Gagal menghapus data: $e');
    }
  }
}

////////////////////////////////////////
///**************Sat konseling service*/
class SatKonselingService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<SatKonselingModel>> getList({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul_sat/konseling/list.php');
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
        List<SatKonselingModel> getList = responseData
            .map((data) => SatKonselingModel.fromJson(data))
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
}
