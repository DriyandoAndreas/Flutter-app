import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app5/models/biodata_model.dart';

class BiodataService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];

  Future<BiodataGacModel> getBioGac({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/biodata/data.php');
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
        final jsonData = json.decode(response.body)['data'];
        return BiodataGacModel.fromJson(jsonData);
      } else {
        throw Exception('error gagal parsing data api');
      }
    } catch (e) {
      return BiodataGacModel();
    }
  }

  Future<BiodataSatModel> getBioSat({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul_sat/biodata/data.php');
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
        final jsonData = json.decode(response.body)['data'];
        return BiodataSatModel.fromJson(jsonData);
      } else {
        throw Exception('error gagal parsing data api');
      }
    } catch (e) {
      return BiodataSatModel();
    }
  }
}
