import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:my_app/utils/SharedPrefences.dart';
import 'package:my_app/utils/url/ApiUrls.dart';

class LoginApi {
  Future<Object> LogIn(String phone, String pass) async {
    var jsonResponse = null;
    String url = ApiUrls.loginURL;
    Map<String, String> headers = {"Content-type": "application/json"};
    String json =
    jsonEncode(<String, String>{'phone': phone, 'password': pass});
    // make POST request
    http.Response response = await http.post(url, headers: headers, body: json);

//   print(response.body);
//    print(response.statusCode);
    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);
      var token = response.headers['x-auth-token'];
      SharedPreferencesManager.setAuthToken(token);
      return jsonResponse;
    } else {
      return jsonResponse;
    }
  }
}
