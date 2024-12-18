import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app5/models/school_landingpage.dart';

class SchoolLandingpageService {
  var apiUrlPalapa = dotenv.env['API_URL_PAPALA'];

  Future<List<SchoolLandingpageModel>> getSchoolHeader(
      {required String npsn}) async {
    var url = Uri.parse('$apiUrlPalapa/sbn/sekolah-header/$npsn');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> responApi = json.decode(response.body)['data'];
        final List<dynamic> responseData = responApi['img'];
        List<SchoolLandingpageModel> datas = responseData
            .map((data) => SchoolLandingpageModel.fromJson(data))
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
