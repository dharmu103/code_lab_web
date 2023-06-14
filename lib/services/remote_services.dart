import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/country_list.dart';
import '../models/deals_list.dart';
import '../models/store_list.dart';

class RemoteService {
  static late String token;
  static const String BASE_URL = "http://54.159.201.11:3000/portal/";
  static const String no_auth = "no-auth";
  static const headers = {'Content-Type': 'application/json'};
  String country = "UAE";

  static Map<String, String> authHeader = {
    "Content-type": "application/json; charset=utf-8",
    "token": token,
  };

  static initiatizeAuthHeader() async {
    authHeader = {
      "Content-type": "application/json; charset=utf-8",
      "token": token,
    };
    print(token);
  }
// http://54.159.201.11:3000/app/no-auth/home?country=UAE
  // static Future<String?> signupWithEmailandPassword(
  //     Map<String, String> map) async {
  //   http.Response res = await http.post(
  //       Uri.parse(BASE_URL + no_auth + "/signup"),
  //       headers: headers,
  //       body: jsonEncode(map));

  //   if (res.statusCode == 200) {
  //     final SharedPreferences pref = await SharedPreferences.getInstance();
  //     pref.setString("accessToken", jsonDecode(res.body)["token"]);
  //     return "";
  //   } else {
  //     return jsonDecode(res.body)["message"];
  //   }
  // }

  static Future<String?> loginWithEmailandPassword(
      Map<String, String> map) async {
    try {
      http.Response res = await http.post(Uri.parse("$BASE_URL$no_auth/login"),
          headers: headers, body: jsonEncode(map));
      // print(res.body);
      if (res.statusCode == 200) {
        token = jsonDecode(res.body)["token"];
        RemoteService.initiatizeAuthHeader();

        final SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("token", jsonDecode(res.body)["token"]);
        return "";
      } else {
        return jsonDecode(res.body)["message"];
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  static Future<StoreList?> fatchStores(String country) async {
    http.Response res = await http.get(
        headers: authHeader,
        // Uri.parse(BASE_URL + no_auth + "/home?country=$country"),
        Uri.parse(
            "http://54.159.201.11:3000/portal/auth/store?country=$country"));

    var resp = jsonDecode(res.body);
    print(res.statusCode);
    if (res.statusCode == 200) {
      // print(res.statusCode);
      // print(res.body);
      return StoreList.fromJson(resp);
    }
    return null;
  }

  static Future getProfile() async {
    http.Response res = await http.get(
        headers: authHeader,
        // Uri.parse(BASE_URL + no_auth + "/home?country=$country"),
        Uri.parse("http://54.159.201.11:3000/app/auth/profile"));

    var resp = jsonDecode(res.body);
    // print(res.statusCode);
    // print(res.body);
    if (res.statusCode == 200) {
      return res.body;
    }
    return jsonDecode(res.body)["message"];
  }

  static Future<DealsList?> fatchDeals(String deal) async {
    print("object");
    try {
      http.Response res = await http.get(
          headers: authHeader,
          // Uri.parse(BASE_URL + no_auth + "/home?country=$country"),
          Uri.parse("http://54.159.201.11:3000/portal/auth/deal?store=$deal"));

      var resp = jsonDecode(res.body);
      // print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        return DealsList.fromJson(resp);
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  static Future<CountryList> fatchCountry() async {
    http.Response? res;
    print("object");
    try {
      res = await http.get(
          // Uri.parse(BASE_URL + no_auth + "/home?country=$country"),
          Uri.parse('${BASE_URL}auth/country'),
          headers: authHeader);
    } catch (e) {
      print(e.toString());
    }
    var resp = jsonDecode(res!.body);
    // print(res.body);
    // print(res.statusCode);

    if (res.statusCode == 200) {
      return CountryList.fromJson(resp);
    }

    return CountryList(message: "Error");
  }

  static Future uploadProfileImage(map) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$BASE_URL/auth/upload-profile-image'));
    request.files.add(await http.MultipartFile.fromPath(
        'file', '/C:/Users/Lenovo/Downloads/get profile.png'));
    request.headers.addAll(authHeader);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  static Future<String> addCountry(map) async {
    var res = await http.post(
        // Uri.parse(BASE_URL + no_auth + "/home?country=$country"),
        Uri.parse('${BASE_URL}auth/create-country'),
        headers: authHeader,
        body: jsonEncode(map));
    // print(res.body);
    return jsonDecode(res.body)["message"];
  }

  static Future<String> addStore(map) async {
    var res = await http.post(
        // Uri.parse(BASE_URL + no_auth + "/home?country=$country"),
        Uri.parse('${BASE_URL}auth/create-store'),
        headers: authHeader,
        body: jsonEncode(map));
    print(res.body);
    print("ye aaya");
    return jsonDecode(res.body)["message"];
  }

  static Future<String> addDeals(map) async {
    var res = await http.post(
        // Uri.parse(BASE_URL + no_auth + "/home?country=$country"),
        Uri.parse('${BASE_URL}auth/create-deal'),
        headers: authHeader,
        body: jsonEncode(map));
    print(res.body);
    print("ye aaya");
    return jsonDecode(res.body)["message"];
  }
}
