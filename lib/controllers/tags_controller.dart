import 'package:code_lab_web/models/tags_model.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

import '../services/remote_services.dart';

class TagController extends GetxController {
  ButtonState btnState = ButtonState.idle;
  int currentPage = 0;
  TagsList? categories = TagsList();
  String? updateTagText = "";
  Categories? updateCatagory = Categories();
  addTagPage() {
    updateTagText = "";
    updateCatagory = Categories();
    currentPage = 1;
    update();
  }

  backPage() {
    currentPage = 0;
    update();
  }

  Future<TagsList?> fatchCategory() async {
    categories = await RemoteService.fatchCategory();
    update();
    return categories;
  }

  addCategery(Map<String, dynamic> map) async {
    btnState = ButtonState.loading;
    update();
    await RemoteService.createCategory(map);
    btnState = ButtonState.success;
    update();
  }

  Future<String?> updateCategery(Map<String, dynamic> map) async {
    btnState = ButtonState.loading;
    update();
    var res = await RemoteService.updateCategory(map);
    btnState = ButtonState.success;
    update();
    return res;
  }

  Future<String?> removeTag(Map<String, dynamic> map) async {
    var res = await RemoteService.deleteCategory(map);
    return res;
  }

  void addDataFormPage(catagory) {
    updateCatagory = catagory;
    currentPage = 1;
    update();
  }
}
