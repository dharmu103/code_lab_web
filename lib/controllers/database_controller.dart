import 'package:code_lab_web/models/deals_list.dart';
import 'package:code_lab_web/models/deals_model.dart';
import 'package:code_lab_web/models/store_list.dart';
import 'package:code_lab_web/models/store_model.dart';
import 'package:code_lab_web/models/users_list.dart';
import 'package:code_lab_web/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

import '../models/banner_list_model.dart';
import '../models/carousel_list.dart';
import '../models/categoriesList.dart';
import '../models/country_model.dart';
import '../models/tags_model.dart';
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
  TagsList? categories = TagsList();
  String? currentCuntry;
  String? currentStore;
  String? currentStoreTitle;

  Rx<DealsModel?> updateFormDealData = DealsModel().obs;
  Rx<StoreModel?> uploadFormStoreData = StoreModel().obs;
  Rx<CountryModel> updateFormCountryData = CountryModel().obs;

  @override
  onInit() {
    fatchCatagory();
    super.onInit();
  }

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
      error = res;
      btnState = ButtonState.idle;
      // Get.snackbar("Error", res.toString(),
      //     backgroundColor: Colors.red, colorText: Colors.white);
    }
    update();
  }

  addDataFormPage(data) {
    if (pageNo.value == 0) {
      updateFormCountryData = data;
      pageNo.value = 10;
    }
    if (pageNo.value == 1) {
      uploadFormStoreData = data;
      pageNo.value = 11;
    }
    if (pageNo.value == 2) {
      // print(data);
      updateFormDealData = data;
      pageNo.value = 12;
    }
    print(pageNo.value);
    update();
  }

  // updateFormPage() {
  //   if (pageNo.value == 0) {
  //     pageNo.value = 10;
  //   }
  //   if (pageNo.value == 1) {
  //     pageNo.value = 11;
  //   }
  //   if (pageNo.value == 2) {
  //     pageNo.value = 12;
  //   }
  //   update();
  // }

  nextPage(CountryModel countryList) async {
    pageNo.value = 1;
    currentCuntry = countryList.countryName;
    // await fatchStore();
    update();
  }

  nextDealsPage(StoreModel store) async {
    pageNo.value = 2;

    currentStore = store.id;
    currentStoreTitle = store.name;
    // await fatchStore();
    update();
  }

  backPage() {
    if (pageNo.value == 0) {
    } else {
      update();
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
    var res = await RemoteService.fatchStores(currentCuntry!);
    // print(res!.stores!.length);
    return res;
  }

  Future<DealsList?> fatchDeals() async {
    var res = await RemoteService.fatchDeals(currentStore!);
    print(res?.dealsList!.length);
    for (var element in res!.dealsList!) {
      print('${element.name!} +${element.image}');
    }
    print(res?.dealsList![0].image);
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
    var res;
    btnState = ButtonState.loading;
    update();
    if (updateFormCountryData.value.countryName == null) {
      res = await RemoteService.addCountry(map);
    } else {
      res = await RemoteService.updateCountry(map);
    }

    btnState = ButtonState.success;
    update();
    return res;
  }

  addStore(map, pickedFile) async {
    var res;
    btnState = ButtonState.loading;
    update();
    if (uploadFormStoreData.value?.id == null) {
      print("2nd  add ye chala");
      res = await RemoteService.addStore(map, pickedFile);
    } else {
      print("2nd  update ye chala");
      res = await RemoteService.updateStore(map, pickedFile);
    }
    btnState = ButtonState.success;
    update();
    return res;
  }

  addDeals(map, pickedFile) async {
    var res;
    btnState = ButtonState.loading;
    update();
    if (updateFormDealData.value?.id == null) {
      res = await RemoteService.addDeals(map, pickedFile);
    } else {
      res = await RemoteService.updateDeals(map, pickedFile);
    }

    btnState = ButtonState.success;
    update();
    return res;
  }

  uploadBanner(map) async {
    btnState = ButtonState.loading;
    update();
    await RemoteService.uploadBanner(map, 'upload-banner');
    btnState = ButtonState.success;

    update();
    await Future.delayed(const Duration(seconds: 2), () {
      btnState = ButtonState.idle;
    });
    update();
  }

  Future<BannerList?> fatchBanner() async {
    var res = await RemoteService.fatchBanner();
    print(res?.banner?.length);
    return res;
  }

  Future<String?> deleteBanner(bannerId) async {
    var res = await RemoteService.deleteBanner(bannerId);

    return res;
  }

  Future<UsersList?> fatchUsers() async {
    var res = await RemoteService.fatchUsers();
    // print(res!.stores!.length);
    return res;
  }

  Future<CarouselList?> fatchcarousel(country) async {
    var res = await RemoteService.fatchCarousel(country);
    print(res?.message);
    return res;
  }

  Future<TagsList?> fatchCatagory() async {
    categories = await RemoteService.fatchCategory();
    update();
    return categories;
  }
}
