import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:sisko_v5/models/perpus_model.dart';

class PerpusService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<PerpusModel>> getList({
    required String id,
    required String tokenss,
    required int limit,
  }) async {
    var url =
        Uri.parse('$apiUrl/client_api/modul/perpus/lists.php?limit=$limit');
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
        List<PerpusModel> beritaList =
            responseData.map((data) => PerpusModel.fromJson(data)).toList();
        return beritaList;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> bukuKembali({
    required String id,
    required String tokenss,
    required String action,
    required String kodeInventaris,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/perpus/exe.php?');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'no_inventaris': kodeInventaris,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      throw Exception('Error, Gagal menambahkan data: $e');
    }
  }

  Future<void> bukuPinjam({
    required String id,
    required String tokenss,
    required String action,
    required String kodeInventaris,
    required String nis,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/perpus/exe.php?');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
      'nis': nis,
      'no_inventaris': kodeInventaris,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      throw Exception('Error, Gagal menambahkan data: $e');
    }
  }
}
