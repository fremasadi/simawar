import 'package:get/get.dart';

import '../../proses/controllers/proses_controller.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(ProsesController());
  }
}
