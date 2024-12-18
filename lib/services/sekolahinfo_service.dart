import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app5/models/sekolahinfo_model.dart';

class SekolahInfoService {
  var apiUrlPalapa = dotenv.env['API_URL_PAPALA'];

  Future<SekolahInfoTop> infoTop({
    required String token,
    required String npsn,
  }) async {
    var url = Uri.parse('$apiUrlPalapa/sbn/sekolah-info-top/$npsn');
    var headers = {
      'token': token,
    };
    try {
      var response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['data'];
        return SekolahInfoTop.fromJson(jsonData);
      } else {
        throw Exception('error gagal parsing data api');
      }
    } catch (e) {
      return SekolahInfoTop();
    }
  }
}
