import 'package:code_lab_web/models/country_list.dart';
import 'package:code_lab_web/models/country_model.dart';
import 'package:code_lab_web/models/store_list.dart';
import 'package:code_lab_web/models/store_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

import '../services/remote_services.dart';

class BannerController extends GetxController {
  PlatformFile? file;
  ButtonState btnState = ButtonState.idle;
  int currentPage = 0;
  CountryModel currentCountry = CountryModel();
  StoreList? storeList = StoreList();
  CountryList countryList = CountryList();
  StoreModel currentStore = StoreModel();
  @override
  void onInit() {
    fatchCountry();
    super.onInit();
  }

  fatchCountry() async {
    countryList = await RemoteService.fatchCountry();
    update();
  }

  nextPage(data) async {
    btnState = ButtonState.idle;
    // if (currentPage == 1) {
    //   updatePageCarousel = data;
    //   currentPage = 2;
    // }
    if (currentPage == 0) {
      currentCountry = data;
      storeList = await RemoteService.fatchStores(currentCountry.countryName!);
      currentPage = 1;
    }
    update();
  }

  void fatchStore(country) async {
    print(country);
    storeList =
        await RemoteService.fatchStores(currentCountry.countryName.toString());
    update();
    print(storeList?.stores?.length ?? "No Data");
  }
}
