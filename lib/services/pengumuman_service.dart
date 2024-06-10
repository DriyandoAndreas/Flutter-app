import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sisko_v5/models/pengumuman_model.dart';
import 'package:http/http.dart' as http;

class PengumumanService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<PengumumanModel>> getList({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url =
        Uri.parse('$apiUrl/client_api/modul/pengumuman/lists.php?limit=$limit');
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
        List<PengumumanModel> pengumumanlist =
            responseData.map((data) => PengumumanModel.fromJson(data)).toList();
        return pengumumanlist;
      } else {
        throw Exception(
            'Failed to get list pengumuman. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addPengumuman({
    required String id,
    required String tokenss,
    required String action,
    required String idc,
    required String imageUrl,
    required String tanggal,
    required String judul,
    required String isi,
    required String wysiwyg,
    required String untuk,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/pengumuman/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'idc': idc,
      'image_url': imageUrl,
      'tanggal': tanggal,
      'judul': judul,
      'isi': isi,
      'wysiwyg': wysiwyg,
      'untuk[]': untuk,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      throw Exception('Error, Gagal menambahkan pengumuman: $e');
    }
  }

  Future<void> editPengumuman({
    required String id,
    required String tokenss,
    required String action,
    required String idc,
    required String imageUrl,
    required String tanggal,
    required String judul,
    required String isi,
    required String wysiwyg,
    required String untuk,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/pengumuman/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'idc': idc,
      'image_url': imageUrl,
      'tanggal': tanggal,
      'judul': judul,
      'isi': isi,
      'wysiwyg': wysiwyg,
      'untuk[]': untuk,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      throw Exception('Error, Gagal edit pengumuman: $e');
    }
  }

  Future<void> deletePengumuman({
    required String id,
    required String tokenss,
    required String action,
    required String idc,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/pengumuman/exe.php');
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
      throw Exception('Error, Gagal menghapus pengumuman(teras sekolah) : $e');
    }
  }
}
