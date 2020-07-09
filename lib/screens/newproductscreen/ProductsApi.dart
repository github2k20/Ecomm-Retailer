import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/utils/SharedPrefences.dart';
import 'package:toast/toast.dart';
import 'package:my_app/utils/url/ApiUrls.dart';
import 'package:flutter/material.dart';
import 'package:my_app/HomePage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';


class Products{
 void addProduct(BuildContext context,String category,String name,String price,String img,Function(int) callback) async {
    String url=ApiUrls.productsURL;
    Map<String, String> headers = {"x-auth-token": await SharedPreferencesManager.getAuthToken(),"Content-type": "application/json"};
    String json= jsonEncode(<String, String>{
      'category':category,
      'name':name,
      'price':price,
      'img':img,
    });
    // make POST request
    http.Response response = await http.post(url, headers: headers, body: json);

    if(response.statusCode == 200) {
      callback(200);
    }

    else {
      callback(400);
    }
  }


  void updateProduct(BuildContext context,String _id,String category,String name,String price,String img) async {
    String url = ApiUrls.updateProductURL+'/${_id}';
    Map<String, String> headers = {"x-auth-token": await SharedPreferencesManager.getAuthToken(),"Content-type": "application/json"};
    String json= jsonEncode(<String, String>{
      'category':category,
      'name':name,
      'price':price,
      'img':img,
    });
    // make PATCH request
    http.Response response = await http.patch(url, headers: headers, body: json);
    print(response.body);
    if(response.statusCode == 200) {
      pushNewScreen(
        context,
        screen:HomePage(),
        platformSpecific: false, // OPTIONAL VALUE. False by default, which means the bottom nav bar will persist
        withNavBar: true, // OPTIONAL VALUE. True by default.
      );
    }
    else {
      Toast.show(
          "Failed to Update Product", context, duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM);
    }
  }
}