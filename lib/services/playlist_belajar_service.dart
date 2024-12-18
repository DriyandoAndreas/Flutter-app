import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app5/models/playlist_belajar_model.dart';

class SatPlayListBelajarService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<List<SatTodayTimeLine>> getToday({
    required String id,
    required String tokenss,
    required int interval,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/akademik/_menu/_todaytimeline.php?interval=$interval');
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
        final List<dynamic> responseData =
            json.decode(response.body)['data']['listdata'];
        List<SatTodayTimeLine> datas = responseData
            .map((data) => SatTodayTimeLine.fromJson(data))
            .toList();
        return datas;
      } else {
        throw Exception('error gagal parsing data api');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<SatTommorowTimeLine>> getTommorrowTimeLine({
    required String id,
    required String tokenss,
    required int interval,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/akademik/_menu/_todaytimeline.php?interval=$interval');
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
        final List<dynamic> responseData =
            json.decode(response.body)['data']['listdata'];
        List<SatTommorowTimeLine> datas = responseData
            .map((data) => SatTommorowTimeLine.fromJson(data))
            .toList();
        return datas;
      } else {
        throw Exception('error gagal parsing data api');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<SatTommorowAfterTimeLine>> getTommorrowAfterTimeLine({
    required String id,
    required String tokenss,
    required int interval,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul_sat/akademik/_menu/_todaytimeline.php?interval=$interval');
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
        final List<dynamic> responseData =
            json.decode(response.body)['data']['listdata'];
        List<SatTommorowAfterTimeLine> datas = responseData
            .map((data) => SatTommorowAfterTimeLine.fromJson(data))
            .toList();
        return datas;
      } else {
        throw Exception('error gagal parsing data api');
      }
    } catch (e) {
      return [];
    }
  }
}
