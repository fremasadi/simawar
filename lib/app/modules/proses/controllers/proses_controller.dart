import 'package:get/get.dart';
import '../../../data/repository/order_repository.dart';

class ProsesController extends GetxController {
  var isLoading = false.obs;
  var orders = [].obs;
  final OrderRepository _orderRepository = OrderRepository();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    final result = await _orderRepository.getOrdersGoing();

    if (result['success'] == true && result['data'] != null) {
      orders.value = result['data'];
    } else {
      orders.value = [];
      Get.snackbar("Pesan", result['message']);
    }
    isLoading.value = false;
  }
}
