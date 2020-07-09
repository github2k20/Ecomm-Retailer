import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:my_app/utils/url/ApiUrls.dart';

class Register{
Future<int> RegisterUser(String name,String phone,String pass,String sname) async {

  String url = ApiUrls.registerURL;
  Map<String, String> headers = {"Content-type": "application/json"};
  String json= jsonEncode(<String, String>{
    'name':name,
    'phone':phone,
    'password': pass,
    'shopName':sname
  });
  // make POST request
  http.Response response = await http.post(url, headers: headers, body: json);
//  print(response.body);
  return response.statusCode;

}


Future<int> getOTP(String mobileNumber) async {
  final http.Response response = await http.get(
    ApiUrls.generateOTP + "?number=" + mobileNumber,
  );
  if (response.statusCode == 200) {
    var jsonResponse=jsonDecode(response.body);
    return jsonResponse['data'];
  } else {
    print(response.statusCode);
    print(response);
  }
}
}