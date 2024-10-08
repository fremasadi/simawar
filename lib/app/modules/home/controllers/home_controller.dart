import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/order.dart'; // Import model Pesanan

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var userId = ''.obs;
  var orders = <Pesanan>[].obs;
  var filterText = ''.obs; // Variabel untuk menyimpan teks filter
  var hasPendingOrder =
      false.obs; // Variabel untuk mengecek pesanan yang sedang dikerjakan

  @override
  void onInit() {
    super.onInit();
    getCurrentUser(); // Mendapatkan user ID saat controller diinisialisasi
    fetchOrders(); // Memanggil fetchOrders
    print(userId);
  }

  // Mendapatkan userId dari pengguna yang sedang login
  void getCurrentUser() {
    var currentUser = _auth.currentUser;
    if (currentUser != null) {
      userId.value = currentUser.uid;
    }
  }

  // Fetch orders sesuai filter
  void fetchOrders() {
    FirebaseFirestore.instance
        .collection('pesanan')
        .where('ditugaskanKe',
            isEqualTo: userId.value) // Filter pesanan sesuai userId
        .snapshots()
        .listen((querySnapshot) {
      var fetchedOrders = querySnapshot.docs
          .map((doc) => Pesanan.fromDocumentSnapshot(doc))
          .toList();

      // Cek apakah ada pesanan yang sedang 'DiKerjakan'
      hasPendingOrder.value =
          fetchedOrders.any((order) => order.status == 'Dikerjakan');

      orders.assignAll(fetchedOrders); // Update daftar pesanan
    });
  }

  // Daftar pesanan yang telah difilter berdasarkan teks pencarian (type)
  List<Pesanan> get filteredOrders {
    if (filterText.value.isEmpty) {
      return orders; // Jika tidak ada teks filter, kembalikan semua pesanan
    } else {
      return orders
          .where((order) =>
              order.type.toLowerCase().contains(filterText.value.toLowerCase()))
          .toList();
    }
  }

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
