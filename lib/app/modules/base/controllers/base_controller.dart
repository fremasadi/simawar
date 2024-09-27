import 'package:get/get.dart';

class BaseController extends GetxController {
  // Rx variable to track the selected index
  var selectedIndex = 0.obs;

  // Function to handle tab changes
  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
