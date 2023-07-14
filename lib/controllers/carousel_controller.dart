import 'package:code_lab_web/models/carousel_list.dart';
import 'package:code_lab_web/services/remote_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

class CarouselController extends GetxController {
  PlatformFile? pickedFile;
  int currentPage = 0;
  Carousel updatePageCarousel = Carousel();
  ButtonState btnState = ButtonState.idle;
  nextPage(data) {
    btnState = ButtonState.idle;
    updatePageCarousel = data;
    currentPage = 1;
    update();
  }

  backPage() {
    currentPage = 0;
    update();
  }

  updateCarousel(text) async {
    btnState = ButtonState.loading;
    update();
    if (pickedFile?.name != null) {
      var imgres = await RemoteService.uploadImageStoreandDeal(pickedFile);
      // print("$map $map2");
      // if(updatePageCarousel.images ==null){
      //   updatePageCarousel.images.first = imares[""]
      // }
      updatePageCarousel.images?.add(imgres["image_name"]);
    }
    pickedFile = null;
    RemoteService.updateCarousel({
      "carousel_id": updatePageCarousel.sId,
      "header": text,
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
