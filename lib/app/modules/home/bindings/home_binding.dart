import 'package:get/get.dart';

import 'package:simawar/app/modules/home/controllers/detail_order_controller.dart';
import 'package:simawar/app/modules/home/controllers/history_controller.dart';
import 'package:simawar/app/modules/proses/controllers/proses_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(
      () => HistoryController(),
    );
    Get.lazyPut<DetailOrderController>(
      () => DetailOrderController(),
    );
    Get.put(HomeController());
    Get.put(ProsesController());
  }
}
