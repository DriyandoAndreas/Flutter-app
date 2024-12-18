import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app5/models/playlist_mengajar_model.dart';

class PlaylistMengajarService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];

  Future<List<TodayTimeLine>> getTodayTimeLine({
    required String id,
    required String tokenss,
    required int interval,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/akademik/_menu/_todaytimeline.php?interval=$interval');
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
        List<TodayTimeLine> datas =
            responseData.map((data) => TodayTimeLine.fromJson(data)).toList();
        return datas;
      } else {
        throw Exception('error gagal parsing data api');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<TommorowTimeLine>> getTommorrowTimeLine({
    required String id,
    required String tokenss,
    required int interval,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/akademik/_menu/_todaytimeline.php?interval=$interval');
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
        List<TommorowTimeLine> datas = responseData
            .map((data) => TommorowTimeLine.fromJson(data))
            .toList();
        return datas;
      } else {
        throw Exception('error gagal parsing data api');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<TommorowAfterTimeLine>> getTommorrowAfterTimeLine({
    required String id,
    required String tokenss,
    required int interval,
  }) async {
    var url = Uri.parse(
        '$apiUrl/client_api/modul/akademik/_menu/_todaytimeline.php?interval=$interval');
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
        List<TommorowAfterTimeLine> datas = responseData
            .map((data) => TommorowAfterTimeLine.fromJson(data))
            .toList();
        return datas;
      } else {
        throw Exception('error gagal parsing data api');
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> updateStatus({
    required String id,
    required String tokenss,
    required String status,
    required String action,
    required String kodeakademik,
    required String idakademik,
  }) async {
    var url = Uri.parse(
        '$apiUrl//client_api/modul/akademik/persiapan/exe.php?action=$action&status=$status');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'param3': idakademik,
      'kode_akademik': kodeakademik,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }
}
