import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AbsensiController extends GetxController {
  var absensiList = <QueryDocumentSnapshot>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAbsensiData();
  }

  void fetchAbsensiData() {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        isLoading(true);

        // Menggunakan snapshots() untuk mendengarkan perubahan data secara real-time
        FirebaseFirestore.instance
            .collection('absensi')
            .doc(userId)
            .collection('absensiHarian') // Gunakan nama koleksi yang benar
            .orderBy('waktu', descending: false) // Urutkan berdasarkan waktu
            .snapshots()
            .listen((snapshot) {
          // Mengupdate absensiList setiap kali data diubah
          absensiList.assignAll(snapshot.docs);
          isLoading(false); // Set isLoading ke false setelah data diambil
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data absensi: $e');
    }
  }
}
