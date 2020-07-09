import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_saver/image_picker_saver.dart';


class Datahelper {
  static final String _API_KEY = "AIzaSyC6eVJ70uJeAgzZGHV6diqwRoBzOReMG4c";
  static final String cx = "008547638620874055182:ukh1bgqpfgk";

  static Future<List<String>> loadImagesFromGoogleTask(String query) async {
    var url = 'www.googleapis.com';

    //Refer to more Query parameters
    //https://developers.google.com/custom-search/v1/reference/rest/v1/cse/list#try-it
    var queryParameters = {
      'q': query,
      'num': '1',
      'start': '1',
      'imgSize': 'medium',
      'searchType': 'image',
      'fileType': 'png|jpeg',
      'key': _API_KEY,
      'cx': cx,
     //'imgColorType':'trans'

    };

    var uri =
    Uri.https(url, '/customsearch/v1', queryParameters);
    print(uri);
    final response = await http.get(uri);
    List<String> links = new List<String>();
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      for (var item in json['items']) {
        links.add(item['link']);
      }

      return links;
    } else
      throw Exception('Failed');
  }
}
