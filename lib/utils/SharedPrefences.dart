import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {

  static Future<String> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  static  Future<String> setUserName(String user_name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', user_name);
  }
  static  Future<int> setYearOfBussiness(int year) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('year', year);
  }
  static Future<int> getYearOfBussiness() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('year');
  }

  static Future<String> getPhoneNumb() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone_number');
  }

  static Future<String> setPhoneNumb(String phone_number) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone_number', phone_number);
  }
  static Future<String> getSSOID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sso_id');
  }

  static Future<String> setSSOID(String sso_id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('sso_id', sso_id);
  }
  static Future<String> getSSOProvider() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sso_provider');
  }

  static Future<String> setSSOProvider(String sso_provider) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('sso_provider', sso_provider);
  }

  static Future<String> getLanguageCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getInt('language_code');
  }

  static Future<String> setLanguageCode(int language_code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('language_code', language_code);
  }
  static Future<String> getGender() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('gender');
  }

  static Future<String> setGender(String gender) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('gender', gender);
  }
  static Future<String> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  static Future<String> setEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
  }
  static Future<String> getCountryCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('country_code');
  }

  static Future<String> setCountryCode(String country_code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('country_code', country_code);
  }
  static Future<String> getPictureUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('pic');
  }

  static Future<String> setPictureUrL(String pic) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('pic', pic);
  }

  static Future<String> getDeviceModel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('model');
  }

  static Future<String> setDeviceModel(String model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('model', model);
  }

  static Future<String> getDeviceBrand() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('brand');
  }
  static Future<String> setFCMToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }
  static Future<String> getFCMToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  static Future<String> setDeviceBrand(String brand) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('brand', brand);
  }
  static Future<int> getUserRegistrationID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_registration_id');
  }
  static Future<int> setUserRegistrationID(int user_registration_id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('user_registration_id', user_registration_id);
  }
  static Future<String> getServiceType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('service_type');
  }
  static Future<String> setServiceType(String service_type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('service_type', service_type);
  }
  static Future<int> getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('company_id');
  }
  static Future<int> setcompanyId(int company_id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('company_id', company_id);
  }
  static Future<String> getCompanyName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('company_name');
  }
  Future save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }
  Future<bool> saveList(List<String> list,String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList(key, list);
  }
  static Future<List<String>> getList(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }
  static Future<bool> removeKey(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
  Future read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }
  static Future<String> setcompanyName(String company_name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('company_name', company_name);
  }
  static Future<String> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  static Future<String> setAuthToken(String auth_token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', auth_token);
  }
  static Future<String> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

}
