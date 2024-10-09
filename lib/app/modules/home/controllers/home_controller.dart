import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/order.dart'; // Import model Pesanan

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var userId = ''.obs;
  var orders = <Pesanan>[].obs;
  var hasPendingOrder =
      false.obs; // Menandai jika ada pesanan yang sedang dikerjakan

  @override
  void onInit() {
    super.onInit();
    getCurrentUser(); // Mendapatkan user ID saat controller diinisialisasi
    fetchOrders(); // Mengambil semua pesanan
  }

  // Mendapatkan userId dari pengguna yang sedang login
  void getCurrentUser() {
    var currentUser = _auth.currentUser;
    if (currentUser != null) {
      userId.value = currentUser.uid;
    }
  }

  // Fetch semua pesanan tanpa filter
  void fetchOrders() {
    FirebaseFirestore.instance
        .collection('pesanan')
        .snapshots()
        .listen((querySnapshot) {
      var fetchedOrders = querySnapshot.docs
          .map((doc) => Pesanan.fromDocumentSnapshot(doc))
          .toList();

      orders.assignAll(fetchedOrders); // Update daftar pesanan

      // Cek jika ada pesanan yang ditugaskan ke user dan statusnya "Dikerjakan"
      hasPendingOrder.value = fetchedOrders.any((order) =>
          order.ditugaskanKe == userId.value && order.status == 'Dikerjakan');
    });
  }

  // Fungsi untuk mendapatkan sapaan berdasarkan waktu
  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return "Selamat Pagi";
    } else if (hour < 14) {
      return "Selamat Siang";
    } else {
      return "Selamat Malam";
    }
  }

  // Method untuk mendapatkan item type dalam bentuk string
  String getItemTypeString(String itemType) {
    return itemType.toString().split('.').last;
  }
}
