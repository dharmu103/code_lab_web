import 'package:code_lab_web/models/deals_list.dart';
import 'package:code_lab_web/models/store_list.dart';
import 'package:code_lab_web/models/store_model.dart';
import 'package:code_lab_web/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/country_model.dart';
import '../services/remote_services.dart';

class DatabaseController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  RxInt pageNo = 10.obs;
  List<StoreModel> stores = [];
  List<CountryModel> countryList = [];
  StoreList storeList = StoreList();

  String? currentCuntry;
  String? currentStore;

  login(map) async {
    var res = await RemoteService.loginWithEmailandPassword(
        {"email": email.text.trim(), "password": password.text});

    if (res == "") {
      Get.offAll(DashboardScreen());
    }
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
    pageNo.value = pageNo.value - 1;
    if (pageNo.value == 1) {
      currentStore = null;
    }
    if (pageNo.value == 0) {
      currentCuntry = null;
    }
    update();
  }

  Future<List<CountryModel>?> fatchCountry() async {
    var res = await RemoteService.fatchCountry();
    print(res);
    print(res.countryList![0].countryName);
    return res.countryList;
  }

  Future<StoreList?> fatchStore() async {
    print("fatch store run");
    var res = await RemoteService.fatchStores(currentCuntry!);
    // print(res!.stores!.length);
    return res;
  }

  Future<DealsList?> fatchDeals() async {
    print("fatch deals run");
    var res = await RemoteService.fatchDeals("");
    // print(res!.stores!.length);
    return res;
  }
}
