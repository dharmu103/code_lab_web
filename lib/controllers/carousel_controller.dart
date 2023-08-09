import 'package:code_lab_web/models/carousel_list.dart';
import 'package:code_lab_web/screens/sliders_screen.dart';
import 'package:code_lab_web/services/remote_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

import '../models/country_model.dart';
import '../models/store_list.dart';

class CarouselController extends GetxController {
  PlatformFile? pickedFile;
  int currentPage = 0;
  CountryModel currentCountry = CountryModel();
  Carousel updatePageCarousel = Carousel();
  ButtonState btnState = ButtonState.idle;
  StoreList? storeList = StoreList();
  nextPage(data) async {
    btnState = ButtonState.idle;
    if (currentPage == 1) {
      updatePageCarousel = data;
      currentPage = 2;
    }
    if (currentPage == 0) {
      currentCountry = data;
      storeList = await RemoteService.fatchStores(currentCountry.countryName!);
      currentPage = 1;
    }
    update();
  }

  backPage() {
    currentPage = 0;
    update();
  }

  deleteImageFromCarousel(text, textArabic, index) async {
    Get.dialog(const Center(child: CircularProgressIndicator()));
    updatePageCarousel.images!.removeAt(index);
    await RemoteService.updateCarousel({
      "carousel_id": updatePageCarousel.sId,
      "header": text,
      "header_arabic": textArabic,
      "images": updatePageCarousel.images
    });
    Get.back();
    update();
  }

  updateCarousel(text, textArabic, store) async {
    btnState = ButtonState.loading;
    update();
    // print(pickedFile?.name);
    // print("pickedFile?.name");
    if (pickedFile?.name != null) {
      var imgres = await RemoteService.uploadImageStoreandDeal(pickedFile);
      // print("$map $map2");
      // if(updatePageCarousel.images ==null){
      //   updatePageCarousel.images.first = imares[""]
      // }
      print(imgres);
      updatePageCarousel.images
          ?.add(Images(store: store, link: imgres["image_name"]));
    }
    // print(updatePageCarousel.images?.last);
    pickedFile = null;
    RemoteService.updateCarousel({
      "carousel_id": updatePageCarousel.sId,
      "header": text,
      "header_arabic": textArabic,
      "images": updatePageCarousel.images
    });
    btnState = ButtonState.success;
    update();
    await Future.delayed(const Duration(seconds: 2), () {
      btnState = ButtonState.idle;
    });
    update();
  }

  void addCarouselPage() {
    currentPage = 100;
    update();
  }

  addCarousel(map) {
    btnState = ButtonState.loading;
    update();
    RemoteService.addCarousel(map);
    btnState = ButtonState.success;
    update();
  }

  Future<String?> deleteCarousel(map) async {
    btnState = ButtonState.loading;
    update();
    var res = await RemoteService.deleteCarousel(map);
    // btnState = ButtonState.success;

    update();
    return res;
  }
}
