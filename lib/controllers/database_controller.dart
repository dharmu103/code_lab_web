import 'package:code_lab_web/models/deals_list.dart';
import 'package:code_lab_web/models/store_list.dart';
import 'package:code_lab_web/models/store_model.dart';
import 'package:code_lab_web/models/users_list.dart';
import 'package:code_lab_web/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

import '../models/country_model.dart';
import '../services/remote_services.dart';

class DatabaseController extends GetxController {
  ButtonState btnState = ButtonState.idle;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  RxInt pageNo = 0.obs;
  List<StoreModel> stores = [];
  List<CountryModel> countryList = [];
  List<CountryModel> countryList1 = [];
  StoreList storeList = StoreList();
  String? error = '';

  String? currentCuntry;
  String? currentStore;

  login(map) async {
    btnState = ButtonState.loading;
    error = "";
    update();
    var res = await RemoteService.loginWithEmailandPassword(
        {"email": email.text.trim(), "password": password.text});

    if (res == "") {
      btnState = ButtonState.success;
      Get.offAll(DashboardScreen());
    } else {
      print(res);
      error = res;
      btnState = ButtonState.idle;
      // Get.snackbar("Error", res.toString(),
      //     backgroundColor: Colors.red, colorText: Colors.white);
    }
    update();
  }

  addDataFormPage() {
    if (pageNo.value == 0) {
      pageNo.value = 10;
    }
    if (pageNo.value == 1) {
      pageNo.value = 11;
    }
    if (pageNo.value == 2) {
      pageNo.value = 12;
    }
    update();
  }

  updateFormPage() {
    if (pageNo.value == 0) {
      pageNo.value = 10;
    }
    if (pageNo.value == 1) {
      pageNo.value = 11;
    }
    if (pageNo.value == 2) {
      pageNo.value = 12;
    }
    update();
  }

  nextPage(CountryModel countryList) async {
    pageNo.value = 1;
    currentCuntry = countryList.countryName;
    // await fatchStore();
    print(pageNo);
    update();
  }

  nextDealsPage(StoreModel store) async {
    pageNo.value = 2;

    currentStore = store.id;
    // await fatchStore();
    print(pageNo);
    update();
  }

  backPage() {
    if (pageNo.value == 0) {
    } else {
      update();
      print('${pageNo.value} ye page no hai');
      if (pageNo > 9) {
        pageNo.value = pageNo.value - 10;
      } else {
        pageNo.value = pageNo.value - 1;
      }
      if (pageNo.value == 1) {
        currentStore = null;
      }
      if (pageNo.value == 0) {
        currentCuntry = null;
      }
    }
    update();
  }

  Future<List<CountryModel>?> fatchCountry() async {
    // print("this country run");

    var res = await RemoteService.fatchCountry();

    // print(countryList1.length);
    return res.countryList;
  }

  Future<StoreList?> fatchStore() async {
    print("fatch store run $currentCuntry");

    var res = await RemoteService.fatchStores(currentCuntry!);
    // print(res!.stores!.length);
    return res;
  }

  Future<DealsList?> fatchDeals() async {
    print("fatch deals run");
    var res = await RemoteService.fatchDeals(currentStore!);
    // print(res!.stores!.length);
    return res;
  }

  Future<String?> removeDeal(map) async {
    var res = await RemoteService.deleteDeals(map);
    await fatchDeals();
    update();
    return res;
  }

  Future<String?> removeStore(map) async {
    var res = await RemoteService.deleteStore(map);
    await fatchStore();
    update();

    return res;
  }

  Future<String?> removeCountry(map) async {
    var res = await RemoteService.deleteCountry(map);
    await fatchCountry();
    update();

    return res;
  }

  addCountry(map) async {
    btnState = ButtonState.loading;
    update();
    var res = await RemoteService.addCountry(map);
    btnState = ButtonState.success;
    update();
    return res;
  }

  addStore(map) async {
    btnState = ButtonState.loading;
    update();
    var res = await RemoteService.addStore(map);
    btnState = ButtonState.success;
    update();
    return res;
  }

  addDeals(map) async {
    btnState = ButtonState.loading;
    update();
    var res = await RemoteService.addDeals(map);
    btnState = ButtonState.success;
    update();
    return res;
  }

  uploadBanner(map) async {
    btnState = ButtonState.loading;
    update();
    await RemoteService.uploadBannerImage(map);
    btnState = ButtonState.idle;
    update();
  }

  Future<UsersList?> fatchUsers() async {
    var res = await RemoteService.fatchUsers();
    // print(res!.stores!.length);
    return res;
  }
}
