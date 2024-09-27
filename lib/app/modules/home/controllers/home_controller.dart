import 'package:get/get.dart';

class HomeController extends GetxController {
  String getGreting() {
    var hour = DateTime.now().hour;

    if (hour < 12) {
      return "Selamat Pagi";
    }
    if (hour < 14) {
      return "Selamat Sore";
    } else {
      return "Selamat Malam";
    }
  }
}
