import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app5/models/user_info_model.dart';

class UserInfo {
  var apiPP = dotenv.env['API_URL_PAPALA'];
  Future<InfoModel> getinfo({required String token}) async {
    var url = Uri.parse('$apiPP/user/info');
    var headers = {'token': token};
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var data = responseData['data'];

      InfoModel userInfo = InfoModel(
        iduser: data['user']['id_user'],
        username: data['user']['username'],
        password: data['user']['password'],
        nomorsc: data['user']['nomor_sc'],
        position: data['user']['position'],
        cpos: data['user']['cpos'],
        photopp: data['user']['photopp'],
        nama: data['user']['nama'],
        kelamin: data['user']['kelamin'],
        email: data['user']['email'],
        join: data['user']['join'],
        lastlogin: data['user']['last_login'],
        siskonpsn: data['user']['sisko_npsn'],
        siskoid: data['user']['sisko_id'],
        siskokode: data['user']['sisko_kode'],
        siskostatuslogin: data['user']['sisko_status_login'],
        verified: data['user']['verified'],
        active: data['user']['activate'],
        activekey: data['user']['activate_key'],
        uploadphoto: data['user']['upload_photo'],
        photo: data['user']['photo'],
        photothumb: data['user']['photo_thumb'],
        photoPP: PhotoPP(
          photodefault: data['user']['photo_pp']['photo_default'],
          photodefaultthumb: data['user']['photo_pp']['photo_default_thumb'],
        ),
        ip: data['user']['ip'],
      );
      return userInfo;
    } else {
      return InfoModel();
    }
  }
}
