import 'package:get/get.dart';

import 'package:simawar/app/modules/home/controllers/detail_order_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailOrderController>(
      () => DetailOrderController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
