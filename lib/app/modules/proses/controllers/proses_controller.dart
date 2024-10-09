import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../data/models/order.dart';

class ProsesController extends GetxController {
  var isLoading = true.obs;
  var orders = <Pesanan>[].obs;
  var userId = ''.obs; // Observable untuk menyimpan userId dari auth

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    getCurrentUser(); // Mendapatkan userId saat inisialisasi controller
  }

  // Mendapatkan userId dari pengguna yang sedang login
  void getCurrentUser() {
    var currentUser = _auth.currentUser;
    if (currentUser != null) {
      userId.value = currentUser.uid;
      fetchOrders(); // Fetch orders setelah mendapatkan userId
    }
  }

  // Fetch orders dengan menggunakan listen untuk real-time updates
  void fetchOrders() {
    isLoading(true); // Set loading state true saat memulai fetch
    FirebaseFirestore.instance
        .collection('pesanan')
        .where('ditugaskanKe',
            isEqualTo: userId.value) // Filter berdasarkan userId
        .snapshots()
        .listen((querySnapshot) {
      var fetchedOrders = querySnapshot.docs
          .map((doc) => Pesanan.fromDocumentSnapshot(doc))
          .where((order) =>
              order.status != 'Selesai') // Filter status != 'Selesai'
          .toList();

      orders.assignAll(fetchedOrders); // Update daftar pesanan
      isLoading(false); // Set loading state ke false setelah fetch selesai
    });
  }
}
