import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/utils/SharedPrefences.dart';
import 'package:toast/toast.dart';
import 'package:my_app/utils/url/ApiUrls.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/homescreen/HomeScreen.dart';

class Products{
  Future<List<Object>> getAllProducts(BuildContext context) async {
    List<Object> allProducts = new List<Object>();
    var jsonResponse = null;
    String url = ApiUrls.productsURL;

    //may be I have to get shared prefences
    Map<String, String> headers = {"x-auth-token": await SharedPreferencesManager.getAuthToken(),"Content-type": "application/json"};
    // make GET request
    http.Response response = await http.get(url, headers: headers);
    //print(response.body);
    if(response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);

      for (var item in jsonResponse) {
        allProducts.add(item);

      }
      return allProducts.reversed.toList();
    }
    else {
      Toast.show(
          "Couldn't find products. Please check your internet connection", context, duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM);
      return null;
    }

  }


  Future<List<Object>> deleteProduct (var _id,BuildContext context) async
  {
    List<Object> allProducts = new List<Object>();
    var jsonResponse = null;
    String url = ApiUrls.productsURL+'/${_id}';
    Map<String, String> headers = {"x-auth-token": await SharedPreferencesManager.getAuthToken(),"Content-type": "application/json"};

    http.Response response = await http.delete(url, headers: headers);
    if(response.statusCode == 200) {
      Toast.show("Product Deleted", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      jsonResponse = jsonDecode(response.body);

      for (var item in jsonResponse) {
        allProducts.add(item);
      }
      return allProducts.reversed.toList();
    }

    else {
      Toast.show(
      "Failed to delete product. Please try again", context, duration: Toast.LENGTH_LONG,
       gravity: Toast.BOTTOM);
      throw Exception('Failed to delete product.');
    }
  }
}