import 'package:get/get.dart';
import '../../../data/repository/order_repository.dart';

class HistoryController extends GetxController {
  final OrderRepository _orderRepository = OrderRepository();
  var completedOrders = <Map<String, dynamic>>[].obs; // List of Maps
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCompletedOrders();
  }

  Future<void> fetchCompletedOrders() async {
    try {
      isLoading.value = true;
      final response = await _orderRepository.getCompletedOrders();
      if (response['success'] && response['data'] is List) {
        completedOrders.value = List<Map<String, dynamic>>.from(
            response['data'].map((e) => Map<String, dynamic>.from(e)));
      } else {
        errorMessage.value = response['message'] ?? "Data tidak ditemukan.";
      }
    } catch (e) {
      errorMessage.value = "Terjadi kesalahan saat mengambil data.";
    } finally {
      isLoading.value = false;
    }
  }
}
