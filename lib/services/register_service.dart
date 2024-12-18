import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  var apiPP = dotenv.env['API_URL_PAPALA'];
  Future<bool> register({
    required String action,
    required String nama,
    required String hp,
    required String email,
    required String position,
    required String password,
  }) async {
    var url = Uri.parse('$apiPP/user/register.exe');
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var body = {
      'action': action,
      'name': nama,
      'hp': hp,
      'email_user': email,
      'position': position,
      'password': password,
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
