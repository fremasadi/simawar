import 'package:get/get.dart';

import '../../proses/controllers/proses_controller.dart';
import '../controllers/absensi_controller.dart';

class AbsensiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbsensiController>(
      () => AbsensiController(),
    );
    Get.put(ProsesController());
  }
}
