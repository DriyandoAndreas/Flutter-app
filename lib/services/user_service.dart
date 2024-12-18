import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app5/models/user_model.dart';

class UserService {
  var apiPP = dotenv.env['API_URL_PAPALA'];
  Future<List<RegisterNumberAt>> getRegisterNumber(
      {required String token}) async {
    var url = Uri.parse('$apiPP/user/registered-number-at');
    var headers = {'token': token};
    var response = await http.get(url, headers: headers);
    try {
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['datas'];
        List<RegisterNumberAt> datas = responseData
            .map((data) => RegisterNumberAt.fromJson(data))
            .toList();
        return datas;
      } else {
        throw Exception('failed to get data');
      }
    } catch (e) {
      return [];
    }
  }

  Future<UserJoinData> join({
    required String token,
    required String action,
    required String npsn,
    required String hp,
    required String nomor,
    required String emailuser,
  }) async {
    var url = Uri.parse('$apiPP/_sisko_/sisko_join.exe');
    var headers = {'token': token};
    var body = {
      'action': action,
      'npsn': npsn,
      'hp': hp,
      'nomor': nomor,
      'email_user': emailuser,
    };
    try {
      var respon = await http.post(url, headers: headers, body: body);
      if (respon.statusCode == 200) {
        var respondata = jsonDecode(respon.body)['data'];
        return UserJoinData.fromJson(respondata);
      } else {
        throw Exception('failded get data');
      }
    } catch (e) {
      return UserJoinData();
    }
  }

  Future<bool> updatePhotoProfile({
    required String action,
    required String data,
    required String content,
    required String nomor,
    required String token,
  }) async {
    var url = Uri.parse('$apiPP/user/photo.exe');
    var headers = {'token': token};
    var body = {
      'action': action,
      'data': data,
      'content': content,
      'nomor': nomor,
    };
    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePassword({
    required String action,
    required String password,
    required String passwordbaru,
    required String passwordBaruconfirm,
    required String hp,
    required String nomor,
    required String token,
    required String siskoid,
  }) async {
    var url = Uri.parse('$apiPP/user/password.exe');
    var headers = {'token': token};
    var body = {
      'action': action,
      'password': password,
      'passwordBaru': passwordbaru,
      'passwordBaru2': passwordBaruconfirm,
      'hp': hp,
      'nomor': nomor,
      'sisko_id': siskoid,
    };
    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateHandphone({
    required String action,
    required String hp,
    required String nomor,
    required String token,
    required String siskoid,
  }) async {
    var url = Uri.parse('$apiPP/user/form_hp.exe');
    var headers = {'token': token};
    var body = {
      'action': action,
      'hp': hp,
      'nomor': nomor,
      'sisko_id': siskoid,
    };
    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProfile({
    required String token,
    required String action,
    required String nama,
    required String tanggallahir,
    required String kelamin,
    required String emailuser,
    required String hp,
    required String nomor,
  }) async {
    var url = Uri.parse('$apiPP/user/profile2.exe');
    var headers = {'token': token};
    var body = {
      'action': action,
      'nama': nama,
      'tgl_lahir': tanggallahir,
      'kelamin': kelamin,
      'email_user': emailuser,
      'hp': hp,
      'nomor': nomor,
    };
    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> setSession({
    required String action,
    required String sessionid,
    required String iduser,
    required String token,
  }) async {
    var url = Uri.parse('$apiPP/user/setSession.exe');
    var headers = {'token': token};
    var body = {
      'action': action,
      'session_id': sessionid,
      'id_user': iduser,
    };
    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
