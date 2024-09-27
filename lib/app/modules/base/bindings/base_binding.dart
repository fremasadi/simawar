import 'package:get/get.dart';
import 'package:simawar/app/modules/home/controllers/home_controller.dart';

import '../controllers/base_controller.dart';

class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BaseController());
    Get.put(HomeController());
  }
}
