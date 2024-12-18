import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ForgetPasswrodService {
  var apiPP = dotenv.env['API_URL_PAPALA'];
  Future<bool> forget({
    required String action,
    required String hp,
    required String email,
  }) async {
    var url = Uri.parse('$apiPP/user/forgot.exe');
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var body = {
      'action': action,
      'hp': hp,
      'email_user': email,
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
