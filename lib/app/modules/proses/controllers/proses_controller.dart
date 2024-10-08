import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../data/models/order.dart';

class ProsesController extends GetxController {
  var isLoading = true.obs;
  var orders = <Pesanan>[].obs;

  // Ganti ini dengan userId yang sesuai
  final String currentUserId = "5P0CnumSqzUHHIT95i5iARGboPX2";

  Future<void> fetchOrders() async {
    try {
      isLoading(true);
      var querySnapshot = await FirebaseFirestore.instance
          .collection('pesanan')
          .where('ditugaskanKe', isEqualTo: currentUserId) // Filter berdasarkan userId
          .get();

      var fetchedOrders = querySnapshot.docs
          .map((doc) => Pesanan.fromDocumentSnapshot(doc))
          .toList();
      orders.assignAll(fetchedOrders);
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }
}
