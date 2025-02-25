import 'package:get/get.dart';

class CategoryController extends GetxController {
  RxList<String> categoryList = RxList<String>([]);

  @override
  void onInit() {
    super.onInit();
    fatchCategories();
  }

  Future<void> fatchCategories() async {}
}
