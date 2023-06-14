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
  RxInt pageNo = 0.obs;
  List<StoreModel> stores = [];
  List<CountryModel> countryList = [];
  List<CountryModel> countryList1 = [];
  StoreList storeList = StoreList();
  String? error = '';

  String? currentCuntry;
  String? currentStore;

  login(map) async {
    error = "";
    update();
    var res = await RemoteService.loginWithEmailandPassword(
        {"email": email.text.trim(), "password": password.text});

    if (res == "") {
      Get.offAll(DashboardScreen());
    } else {
      print(res);
      error = res;
      Get.snackbar("Error", res.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
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
    print("this country run");
    var res = await RemoteService.fatchCountry();
    print(res.countryList?.length);
    print(res.countryList![1].countryName);
    res.countryList!.forEach((element) {
      print('${element.countryName}----------------------');
      if (element.countryName!.isNotEmpty) {
        countryList1.add(element);
      }
    });
    print(countryList1.length);
    return countryList1;
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
}
