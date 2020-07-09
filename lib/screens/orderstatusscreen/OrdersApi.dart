import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/utils/SharedPrefences.dart';
import 'package:toast/toast.dart';
import 'package:my_app/utils/url/ApiUrls.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/homescreen/HomeScreen.dart';

class Orders{

  Future<List<Object>> getPendingOrders(BuildContext context) async {
    List<Object> pendingOrders = new List<Object>();
    var jsonResponse = null;
    String url = ApiUrls.pendingOrdersURL;
    Map<String, String> headers = {"x-auth-token": await SharedPreferencesManager.getAuthToken(),"Content-type": "application/json"};
    http.Response response = await http.get(url, headers: headers);
    if(response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);
          for (var item in jsonResponse) {
        pendingOrders.add(item);
      }
      return pendingOrders.reversed.toList();
    }
    else {
      Toast.show("Failed to Load Products", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return [];
    }

  }

  void UpdateStatus(BuildContext context,var id) async {
    var jsonResponse = null;
    String url = ApiUrls.updateOrderStatusURL;
    Map<String, String> headers = {"x-auth-token":await SharedPreferencesManager.getAuthToken(),"Content-type": "application/json"};
    String json= jsonEncode(<String, String>{
      '_id':id,
    });
    http.Response response = await http.patch(url, headers: headers,body:json);
    if(response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);
      Toast.show("Status Changed", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
    else {
      Toast.show("Failed to Update Status", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }


  Future<List<Object>> getCompletedOrders(BuildContext context) async {
    List<Object> completedOrders = new List<Object>();
    var jsonResponse = null;
    String url = ApiUrls.completedOrdersURL;
    Map<String, String> headers = {"x-auth-token":await SharedPreferencesManager.getAuthToken(),"Content-type": "application/json"};
    http.Response response = await http.get(url, headers: headers);
    if(response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);
      for (var item in jsonResponse) {
        completedOrders.add(item);
      }
      return completedOrders.reversed.toList();
    }
    else {
      Toast.show("Failed to Load Products", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return [];
    }
  }
}