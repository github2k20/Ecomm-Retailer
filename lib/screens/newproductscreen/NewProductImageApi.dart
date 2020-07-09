import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/utils/url/ApiUrls.dart';


Future<String> saveImage(String img64) async{
  final uri =ApiUrls.storingImageOnline;
  var map = new Map<String, dynamic>();
  map['image'] =img64;
  http.Response response = await http.post(
    uri,
    body: map,
  );

  print(response.body);
  var jsonResponse = jsonDecode(response.body);
  return jsonResponse['data']['url'];
}