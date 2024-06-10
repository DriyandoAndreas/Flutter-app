import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:sisko_v5/models/user_model.dart';

class AuthService {
  var apiPP = dotenv.env['API_URL_PAPALA'];
  Future<UserModel> login({
    required String action,
    required String hp,
    required String password,
  }) async {
    var url = Uri.parse('$apiPP/user/login');
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var body = {
      'action': action,
      'hp': hp,
      'password': password,
    };

    var response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      // print('respon dari api auth user: ${responseData.body}');
      var data = responseData['data'];
      UserModel user = UserModel(
        nama: data['nama'],
        hp: data['hp'],
        statusLogin: data['status_login'],
        token: data['token'],
        tokenpp: data['tokenpp'],
        tokenss: data['tokenss'],
        siskohakakses: data['sisko_kode_hakakses'],
        emailUser: data['email_user'],
        imgUrl: ImgUrl(
            photoThumb: data['img_url']['photo_thumb'],
            photo: data['img_url']['photo'],
            photoPp: PhotoPp(
              photoDefault: data['img_url']['photo_pp']['photo_default'],
              photoDefaultThumb: data['img_url']['photo_pp']
                  ['photo_default_thumb'],
            )),
      );
      return user;
    } else {
      throw Exception('Failed to login. Status code: ${response.statusCode}');
    }
  }
}
