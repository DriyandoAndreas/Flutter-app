import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app5/models/perpus_model.dart';

///////////////////////////////////////////
///******Gac perpus service */
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
      return [];
    }
  }

  Future<int> bukuKembali({
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
      var response = await http.post(url, headers: headers, body: body);
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  Future<int> bukuPinjam({
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
      var response = await http.post(url, headers: headers, body: body);

      // Return status code to the caller
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}

//////////////////////////////////////
///******Sat perpus service */
class SatPerpusService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<SatPerpusModel>> getList({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul_sat/perpus/list.php?');
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
        final List<dynamic> responbuku = responseData['buku'];
        List<SatPerpusModel> listbuku =
            responbuku.map((data) => SatPerpusModel.fromJson(data)).toList();
        return listbuku;
      } else {
        throw Exception(
            'Failed to get list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }
}
