import 'package:get/get.dart';
import 'package:simawar/app/modules/absensi/controllers/absensi_controller.dart';
import 'package:simawar/app/modules/home/controllers/detail_order_controller.dart';
import 'package:simawar/app/modules/home/controllers/home_controller.dart';
import 'package:simawar/app/modules/proses/controllers/proses_controller.dart';

import '../controllers/base_controller.dart';

class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BaseController());
    Get.put(HomeController());
    Get.put(DetailOrderController());
    Get.put(ProsesController());
    Get.put(AbsensiController());
  }
}
