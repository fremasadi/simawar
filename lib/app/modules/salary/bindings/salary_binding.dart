import 'package:get/get.dart';

import '../../proses/controllers/proses_controller.dart';
import '../controllers/salary_controller.dart';

class SalaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalaryController>(
      () => SalaryController(),
    );
    Get.put(ProsesController());
  }
}
