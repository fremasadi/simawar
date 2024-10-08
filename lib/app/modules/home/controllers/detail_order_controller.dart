import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DetailOrderController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> assignOrder(String orderId) async {
    try {
      // Ambil userId dari pengguna yang sedang login
      User? user = _auth.currentUser;
      print(user);

      if (user != null) {
        // Update status pesanan dengan userId yang sedang login
        await FirebaseFirestore.instance
            .collection('pesanan')
            .doc(orderId)
            .update({
          'status': 'Dikerjakan',
          'ditugaskanKe': user.uid,
          // Ganti dengan userId dari pengguna yang login
        });

        // Refresh daftar pesanan
        Get.snackbar("Berhasil", "Pesanan berhasil diambil!");
      } else {
        // Jika user tidak ditemukan (belum login)
        Get.snackbar("Error", "Gagal mengambil pesanan: Pengguna tidak login");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil pesanan: $e");
    }
  }
}
