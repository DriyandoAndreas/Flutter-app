import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app5/models/referral_model.dart';

class ReferralService {
  var apiUrl = dotenv.env['API_URL_SISKO_DEV'];
  Future<void> add({
    required String id,
    required String tokenss,
    required String action,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/aff/exe.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    var body = {
      'action': action,
    };
    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      return;
    }
  }

  Future<ReferralModel> getReferralData({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/aff/aff_data.php');
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
        final Map<String, dynamic> datas = json.decode(response.body)['data'];
        return ReferralModel.fromJson(datas);
      } else {
        return ReferralModel();
      }
    } catch (e) {
      return ReferralModel();
    }
  }

  Future<ReferralDashboardModel> getDashboard({
    required String id,
    required String tokenss,
  }) async {
    var url = Uri.parse('$apiUrl/client_api/modul/aff/aff_dashboard.php');
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
        final Map<String, dynamic> datas = json.decode(response.body)['data'];
        return ReferralDashboardModel.fromJson(datas);
      } else {
        return ReferralDashboardModel();
      }
    } catch (e) {
      return ReferralDashboardModel();
    }
  }

  Future<List<ReferralSekolahAktifModel>> getSekolahAktif(
      {required String id, required String tokenss}) async {
    var url = Uri.parse('$apiUrl/client_api/modul/aff/list_sekolah_yreg.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      var response = await http.get(
        url,
        headers: headers,
      );
      final List<dynamic> responseData = json.decode(response.body)['datas'];
      List<ReferralSekolahAktifModel> sekolahyreg = responseData
          .map((data) => ReferralSekolahAktifModel.fromJson(data))
          .toList();
      return sekolahyreg;
    } catch (e) {
      return [];
    }
  }

  Future<List<ReferralSekolahBelumAktifModel>> getSekolahBelumAktif(
      {required String id, required String tokenss}) async {
    var url = Uri.parse('$apiUrl/client_api/modul/aff/list_sekolah_nreg.php');
    var headers = {
      'ID': id,
      'tokenss': tokenss,
    };
    try {
      var response = await http.get(
        url,
        headers: headers,
      );
      final List<dynamic> responseData = json.decode(response.body)['datas'];
      List<ReferralSekolahBelumAktifModel> sekolahyreg = responseData
          .map((data) => ReferralSekolahBelumAktifModel.fromJson(data))
          .toList();
      return sekolahyreg;
    } catch (e) {
      return [];
    }
  }
}
