import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app5/models/teras_sekolah_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BeritaService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<TerasSekolahModel>> getList({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url =
        Uri.parse('$apiUrl/client_api/modul/berita/lists.php?limit=$limit');
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
        List<TerasSekolahModel> beritaList = responseData
            .map((data) => TerasSekolahModel.fromJson(data))
            .toList();
        return beritaList;
      } else {
        throw Exception(
            'Failed to get list berita. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> addBerita({
    required String id,
    required String tokenss,
    required String action,
    required String idc,
    required String imageUrl,
    required String tanggal,
    required String tanggalkadaluarsa,
    required String judul,
    required String isi,
    required String wysiwyg,
    required String untuk,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/berita/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'idc': idc,
      'image_url': imageUrl,
      'tanggal': tanggal,
      'tanggal_kadaluarsa': tanggalkadaluarsa,
      'judul': judul,
      'isi': isi,
      'wysiwyg': wysiwyg,
      'untuk[]': untuk,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }

  Future<void> editBerita({
    required String id,
    required String tokenss,
    required String action,
    required String idc,
    required String imageUrl,
    required String tanggal,
    required String tanggalkadaluarsa,
    required String judul,
    required String isi,
    required String wysiwyg,
    required String untuk,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/berita/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'idc': idc,
      'image_url': imageUrl,
      'tanggal': tanggal,
      'tanggal_kadaluarsa': tanggalkadaluarsa,
      'judul': judul,
      'isi': isi,
      'wysiwyg': wysiwyg,
      'untuk[]': untuk,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }

  Future<void> deleteBerita({
    required String id,
    required String tokenss,
    required String action,
    required String idc,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/berita/exe.php');
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
