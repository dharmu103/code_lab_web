import 'package:get/get.dart';

class SideMenuController extends GetxController {
  RxInt currentPage = 0.obs;

  changeIndex(index) {
    currentPage.value = index;
  }
}
