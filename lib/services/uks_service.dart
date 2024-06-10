import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sisko_v5/models/uks_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UksService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<UksModel>> getList({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/uks/lists.php?limit=$limit');
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
        List<UksModel> getList =
            responseData.map((data) => UksModel.fromJson(data)).toList();
        return getList;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<UksListKelasModel>> getListKelas({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url =
        Uri.parse('$apiUrl/client_api/modul/uks/lists-kelas.php?limit=$limit');
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
        List<UksListKelasModel> getList = responseData
            .map((data) => UksListKelasModel.fromJson(data))
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

  Future<List<UksListSiswaModel>> getListSiswa({
    required String id,
    required String tokenss,
    required String kodeKelas,
    required int limit,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/uks/lists-siswa.php?kode_kelas=$kodeKelas&limit=$limit');
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
        List<UksListSiswaModel> getList = responseData
            .map((data) => UksListSiswaModel.fromJson(data))
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

  Future<List<UksListGrModel>> getListGuru({
    required String id,
    required String tokenss,
    required String kodeKelas,
    required int limit,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/uks/lists-guru.php?kode_kelas=$kodeKelas&limit=$limit');
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
        List<UksListGrModel> getList =
            responseData.map((data) => UksListGrModel.fromJson(data)).toList();
        return getList;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<UksListObatModel>> getObat({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/uks/lists-obat.php?');
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
        List<UksListObatModel> getList = responseData
            .map((data) => UksListObatModel.fromJson(data))
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

  Future<List<UksViewObatModel>> getObatDetail({
    required String id,
    required String tokenss,
    required String param2,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/uks/lists-view-obat.php?param2=$param2');
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
        List<UksViewObatModel> getList = responseData
            .map((data) => UksViewObatModel.fromJson(data))
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

  Future<void> addUks({
    required String id,
    required String tokenss,
    required String action,
    required String nis,
    required String tgl,
    required String diagnosa,
    required String ket,
    required String obat0,
    required String obat1,
    required String stock0,
    required String stock1,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/uks/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'nis': nis,
      'tgl': tgl,
      'diagnosa': diagnosa,
      'ket': ket,
      'obat[0]': obat0,
      'obat[1]': obat1,
      'stock[0]': stock0,
      'stock[1]': stock1,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      throw Exception('Error, Gagal menambahkan data: $e');
    }
  }

  Future<void> editUks({
    required String id,
    required String tokenss,
    required String action,
    required String kdPeriksa,
    required String nis,
    required String tgl,
    required String diagnosa,
    required String ket,
    required String obat0,
    required String obat1,
    required String stock0,
    required String stock1,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/uks/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'kd_periksa': kdPeriksa,
      'nis': nis,
      'tgl': tgl,
      'diagnosa': diagnosa,
      'ket': ket,
      'obat[0]': obat0,
      'obat[1]': obat1,
      'stock[0]': stock0,
      'stock[1]': stock1,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      throw Exception('Error, Gagal edit data: $e');
    }
  }

  Future<void> deleteUks({
    required String id,
    required String tokenss,
    required String action,
    required String kdPeriksa,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/uks/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'idc': kdPeriksa,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      throw Exception('Error, Gagal menambahkan data: $e');
    }
  }
}
