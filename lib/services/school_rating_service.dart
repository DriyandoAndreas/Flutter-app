import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app5/models/school_rating_model.dart';

class SchoolRatingService {
  var apiUrlPalapa = dotenv.env['API_URL_PAPALA'];

  Future<SchoolRatingModel> getRating({
    required String token,
    required String npsn,
  }) async {
    var url = Uri.parse('$apiUrlPalapa/sbn/review-rate/$npsn');
    var headers = {
      'token': token,
    };
    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        return SchoolRatingModel.fromJson(responseData);
      } else {
        throw Exception('error gagal parsing data api');
      }
    } catch (e) {
      return SchoolRatingModel();
    }
  }

  Future<List<SchoolReviewerModel>> getReviewer({
    required String token,
    required String npsn,
  }) async {
    var url = Uri.parse('$apiUrlPalapa/sbn/review_data/$npsn');
    var headers = {
      'token': token,
    };
    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['datas'];
        List<SchoolReviewerModel> datas = responseData
            .map((data) => SchoolReviewerModel.fromJson(data))
            .toList();

        return datas;
      } else {
        throw Exception('error gagal parsing data api');
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> addComments({
    required String token,
    required String npsn,
    required Map<String, dynamic> data,
    required String komentar,
    required String action,
  }) async {
    var url = Uri.parse('$apiUrlPalapa/sbn/review-rate.exe');
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'token': token,
    };
    var body = {
      'action': action,
      'npsn': npsn,
      'komentar': komentar,
    };
    data.forEach((key, value) {
      body[key] = value.toString(); // Convert the double value to string
    });
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }
}
