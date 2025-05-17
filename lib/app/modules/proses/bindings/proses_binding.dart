import 'package:get/get.dart';

import '../controllers/proses_controller.dart';

class ProsesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProsesController());
  }
}
