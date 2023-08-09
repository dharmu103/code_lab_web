import 'dart:convert';
import 'dart:io';
import 'package:code_lab_web/models/banner_list_model.dart';
import 'package:code_lab_web/models/categoriesList.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/carousel_list.dart';
import '../models/country_list.dart';
import '../models/deals_list.dart';
import '../models/store_list.dart';
import '../models/tags_model.dart';
import '../models/users_list.dart';

class RemoteService {
  static late String token;
  // static const String baseUrl = "http://localhost:3000/portal";
  static const String baseUrl = "http://54.159.201.11:3000/portal";
  static const String noAuth = "/no-auth";
  static const headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json, text/plain'
  };

  static Map<String, String> authHeader = {
    "Content-Type": "application/json; charset=utf-8",
    "token": token,
  };

  static initiatizeAuthHeader() async {
    authHeader = {
      "Content-type": "application/json; charset=utf-8",
      'Accept': 'application/json, text/plain',
      "token": token,
    };
  }
// $baseUrl-auth/home?country=UAE
  // static Future<String?> signupWithEmailandPassword(
  //     Map<String, String> map) async {
  //   http.Response res = await http.post(
  //       Uri.parse(baseUrl + noAuth + "/signup"),
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
  // static void test() async {
  //   try {
  //     var request = http.Request(
  //         'GET', Uri.parse('http://54.159.201.11:3000/app/no-auth/country'));
  //     request.body = '''''';

  //     http.StreamedResponse response = await request.send();

  //     if (response.statusCode == 200) {
  //       Get.snackbar("response", await response.stream.bytesToString());
  //       print(await response.stream.bytesToString());
  //     } else {
  //       Get.snackbar("response", response.reasonPhrase.toString());
  //       print(response.reasonPhrase);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  static Future<String?> loginWithEmailandPassword(
      Map<String, String> map) async {
    try {
      // var url = "https://fakestoreapi.com/products";
      // http.Response res = await http.get(Uri.parse(url), headers: headers);
      // http.Response res = await http.post(Uri.parse(url),
      http.Response res = await http.post(Uri.parse("$baseUrl$noAuth/login"),
          headers: headers, body: jsonEncode(map));
      // return res.statusCode.toString() + jsonEncode(res.body);
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
    return null;
  }

  static Future<StoreList?> fatchStores(String country) async {
    http.Response res = await http.get(
        headers: authHeader,
        // Uri.parse(baseUrl + noAuth + "/home?country=$country"),
        Uri.parse("$baseUrl/auth/store?country=$country"));

    var resp = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return StoreList.fromJson(resp);
    }
    return null;
  }

  static Future getProfile() async {
    http.Response res = await http.get(
        headers: authHeader,
        // Uri.parse(baseUrl + noAuth + "/home?country=$country"),
        Uri.parse("$baseUrl/auth/profile"));

    var resp = jsonDecode(res.body);
    // print(res.statusCode);
    // print(res.body);

    if (res.statusCode == 200) {
      return res.body;
    }
    return jsonDecode(res.body)["message"];
  }

  static Future<DealsList?> fatchDeals(String deal) async {
    try {
      http.Response res = await http.get(
          headers: authHeader,
          // Uri.parse(baseUrl + noAuth + "/home?country=$country"),
          Uri.parse("$baseUrl/auth/deal?store=$deal"));
      var resp = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DealsList.fromJson(resp);
      }
    } catch (e) {}
    return null;
  }

  static Future<CountryList> fatchCountry() async {
    http.Response? res;
    try {
      res = await http.get(
          // Uri.parse(baseUrl + noAuth + "/home?country=$country"),
          Uri.parse('$baseUrl/auth/country'),
          headers: authHeader);
    } catch (e) {}
    var resp = jsonDecode(res!.body);
    if (res.statusCode == 200) {
      return CountryList.fromJson(resp);
    }

    return CountryList(message: "Error");
  }

  static Future uploadImage(map, endPoint) async {
    // var request = http.MultipartRequest(
    //   'POST',
    //   Uri.parse(BASE_URL + '/app/' + "upload-profile-image"),
    // );
    try {
      var request = http.MultipartRequest('POST',
          Uri.parse('http://54.159.201.11:3000/portal/auth/upload-image'));

      request.files.add(http.MultipartFile(
        'file',
        map['image'].readStream,
        map['image'].size,
        filename: map['image'].name,
      ));

      request.headers.addAll(authHeader);

      http.StreamedResponse res = await request.send();

      var responseData = await http.Response.fromStream(res);

      var response = jsonDecode(responseData.body);
      if (responseData.statusCode == 200) {
        return response;
      } else {
        return {
          "status": 400,
          "message": "Failed to upload profile image!",
        };
      }
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to upload profile image!",
      };
    }
  }

  static Future uploadBanner(map, endPoint) async {
    var res = await uploadImage(map, endPoint);
    print(res);
    var newmap = {
      "store": map["store"],
      "country": map["country"],
      "image": res["image_name"]
    };
    var resp = await http.post(
        // Uri.parse(baseUrl + noAuth + "/home?country=$country"),
        Uri.parse('$baseUrl/auth/create-banner'),
        headers: authHeader,
        body: jsonEncode(newmap));
    // print(res.body);
    return jsonDecode(resp.body)["message"];
  }

  static Future uploadImageStoreandDeal(
    PlatformFile? pickedFile,
  ) async {
    // print("$map1 + ${map2["deal_id"]} + $endPoint");
    try {
      var request = http.MultipartRequest('POST',
          Uri.parse('http://54.159.201.11:3000/portal/auth/upload-image'));

      request.files.add(http.MultipartFile(
        'file',
        pickedFile!.readStream!,
        pickedFile.size,
        filename: pickedFile.name.toString(),
      ));

      request.headers.addAll(authHeader);

      http.StreamedResponse res = await request.send();

      var responseData = await http.Response.fromStream(res);

      var response = jsonDecode(responseData.body);
      if (responseData.statusCode == 200) {
        return response;
      } else {
        return {
          "status": 400,
          "message": "Failed to upload profile image!",
        };
      }
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to upload profile image!",
      };
    }
  }

  static Future<String> addCountry(map) async {
    var res = await http.post(
        // Uri.parse(baseUrl + noAuth + "/home?country=$country"),
        Uri.parse('$baseUrl/auth/create-country'),
        headers: authHeader,
        body: jsonEncode(map));
    // print(res.body);
    return jsonDecode(res.body)["message"];
  }

  static Future<String> updateCountry(map) async {
    var res = await http.post(
        // Uri.parse(baseUrl + noAuth + "/home?country=$country"),
        Uri.parse('$baseUrl/auth/update-country'),
        headers: authHeader,
        body: jsonEncode(map));
    // print(res.body);
    return jsonDecode(res.body)["message"];
  }

  static Future<String> addStore(map, pickedFile) async {
    if (pickedFile != null) {
      var imgres = await uploadImageStoreandDeal(pickedFile);
      // print("$map $map2");
      map["logo"] = imgres["image_name"];
    }
    var res = await http.post(
        // Uri.parse(baseUrl + noAuth + "/home?country=$country"),
        Uri.parse('$baseUrl/auth/create-store'),
        headers: authHeader,
        body: jsonEncode(map));
    return jsonDecode(res.body)["message"];
  }

  static Future<String> updateStore(map, pickedFile) async {
    if (pickedFile != null) {
      var imgres = await uploadImageStoreandDeal(pickedFile);
      // print("$map $map2");
      map["logo"] = imgres["image_name"];
    }

    var res = await http.post(
        // Uri.parse(baseUrl + noAuth + "/home?country=$country"),
        Uri.parse('$baseUrl/auth/update-store'),
        headers: authHeader,
        body: jsonEncode(map));
    return jsonDecode(res.body)["message"];
  }

  static Future<String> addDeals(map, pickedFile) async {
    if (pickedFile != null) {
      var imgres = await uploadImageStoreandDeal(pickedFile);
      // print("$map $map2");
      map["image"] = imgres["image_name"];
    }

    var res = await http.post(
        // Uri.parse(baseUrl + noAuth + "/home?country=$country"),
        Uri.parse('$baseUrl/auth/create-deal'),
        headers: authHeader,
        body: jsonEncode(map));
    return jsonDecode(res.body)["message"];
  }

  static Future<String> updateDeals(map, pickedFile) async {
    if (pickedFile != null) {
      var imgres = await uploadImageStoreandDeal(pickedFile);
      // print("$map $map2");
      map["image"] = imgres["image_name"];
    }

    var res = await http.post(
        // Uri.parse(baseUrl + noAuth + "/home?country=$country"),
        Uri.parse('$baseUrl/auth/update-deal'),
        headers: authHeader,
        body: jsonEncode(map));
    print(res.body);
    return jsonDecode(res.body)["message"];
  }

  static Future<String> deleteCountry(map) async {
    http.Response res = await http.post(
        // Uri.parse(baseUrl + noAuth + "/home?country=$country"),
        Uri.parse('$baseUrl/auth/remove-country'),
        headers: authHeader,
        body: jsonEncode(map));
    // print(res.body);
    return jsonDecode(res.body)["message"];
  }

  static Future<String> deleteStore(map) async {
    var res = await http.post(
        // Uri.parse(baseUrl + noAuth + "/home?country=$country"),
        Uri.parse('$baseUrl/auth/remove-store'),
        headers: authHeader,
        body: jsonEncode(map));
    return jsonDecode(res.body)["message"];
  }

  static Future<String> deleteDeals(map) async {
    var res = await http.post(
        // Uri.parse(baseUrl + noAuth + "/home?country=$country"),
        Uri.parse('$baseUrl/auth/remove-deal'),
        headers: authHeader,
        body: jsonEncode(map));
    return jsonDecode(res.body)["message"];
  }

  static Future<UsersList?> fatchUsers() async {
    try {
      http.Response res = await http.get(
          headers: authHeader,
          // Uri.parse(baseUrl + noAuth + "/home?country=$country"),
          Uri.parse("$baseUrl/auth/users"));

      var resp = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return UsersList.fromJson(resp);
      }
    } catch (e) {}
    return null;
  }

  static Future<BannerList?> fatchBanner() async {
    http.Response res =
        await http.get(headers: authHeader, Uri.parse("$baseUrl/auth/banner"));
    var resp = jsonDecode(res.body);
    print(resp);
    if (res.statusCode == 200) {
      return BannerList.fromJson(resp);
    }

    return BannerList(message: "Unsuccess", banner: []);
  }

  static Future<String?> deleteBanner(bannerId) async {
    http.Response res = await http.get(
        headers: authHeader,
        Uri.parse("$baseUrl/auth/delete/banner?banner_id=$bannerId"));
    var resp = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return resp["message"];
    }
    return "Failed";
  }

  static Future<CarouselList?> fatchCarousel(country) async {
    http.Response res = await http.get(
        headers: authHeader,
        Uri.parse(
            "http://54.159.201.11:3000/app/no-auth/carousel?country=$country"));
    var resp = jsonDecode(res.body);
    print(resp);
    if (res.statusCode == 200) {
      return CarouselList.fromJson(resp);
    } else {
      return CarouselList(message: "Unsuccess");
    }
  }

  static Future<String?> updateCarousel(map) async {
    http.Response res = await http.post(
        headers: authHeader,
        Uri.parse("$baseUrl/auth/update-carousel"),
        body: jsonEncode(map));
    var resp = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return resp["message"];
    } else {
      return "Failed";
    }
  }

  static Future<String?> addCarousel(map) async {
    http.Response res = await http.post(
        headers: authHeader,
        Uri.parse("$baseUrl/auth/create-carousel"),
        body: jsonEncode(map));
    return null;
  }

  static Future<String?> deleteCarousel(map) async {
    http.Response res = await http.post(
        headers: authHeader,
        Uri.parse("$baseUrl/auth/delete-carousel"),
        body: jsonEncode(map));
    return jsonDecode(res.body)["message"];
  }

  static Future<TagsList?> fatchCategory() async {
    try {
      http.Response res = await http.get(
        headers: authHeader,
        Uri.parse("http://54.159.201.11:3000/portal/auth/category/fetch"),
      );
      var resp = jsonDecode(res.body);
      // print(resp);
      // print(resp);
      return TagsList.fromJson(resp);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      // print(e.toString());
    }
    return null;
  }

  static Future<String?> deleteCategory(map) async {
    try {
      http.Response res = await http.post(
          headers: authHeader,
          Uri.parse("http://54.159.201.11:3000/portal/auth/category/delete"),
          body: jsonEncode(map));
      var resp = jsonDecode(res.body);
      print(resp);
      return resp["message"];
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return null;
  }

  static Future<String?> updateCategory(map) async {
    try {
      http.Response res = await http.post(
          headers: authHeader,
          Uri.parse("http://54.159.201.11:3000/portal/auth/category/update"),
          body: jsonEncode(map));
      var resp = jsonDecode(res.body);
      print(resp);
      return resp["message"];
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      print("error hu mai");
    }
    return null;
  }

  static Future<String?> createCategory(map) async {
    try {
      http.Response res = await http.post(
          headers: authHeader,
          Uri.parse("http://54.159.201.11:3000/portal/auth/category/create"),
          body: jsonEncode(map));
      var resp = jsonDecode(res.body);
      print(resp);
      return resp["message"];
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return null;
  }
}
