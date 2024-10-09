import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AbsensiController extends GetxController {
  var absensiList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchAbsensiData();
  }

  // Fungsi untuk mengambil data absensi berdasarkan userId dari Firebase Auth
  Future<void> fetchAbsensiData() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) {
        // Handle jika user tidak ditemukan (misalnya belum login)
        return;
      }
      final userId = user.uid;

      // Query ke Firestore berdasarkan userId
      QuerySnapshot snapshot = await _firestore
          .collection('absensi')
          .where('userId', isEqualTo: userId)
          .orderBy('waktuAbsen', descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
      } else {}

      // Memproses data absensi dan mengelompokkan berdasarkan tanggal
      Map<String, Map<String, dynamic>> groupedData = {};

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        // Log untuk memastikan data yang diambil benar

        var tanggal = DateFormat('yyyy-MM-dd')
            .format((data['waktuAbsen'] as Timestamp).toDate());

        if (!groupedData.containsKey(tanggal)) {
          groupedData[tanggal] = {
            'tanggal': tanggal,
            'Masuk': '-',
            'Keluar': '-',
          };
        }

        if (data['tipeAbsen'] == 'Masuk') {
          groupedData[tanggal]!['Masuk'] = DateFormat('HH:mm')
              .format((data['waktuAbsen'] as Timestamp).toDate());
        } else if (data['tipeAbsen'] == 'Keluar') {
          groupedData[tanggal]!['Keluar'] = DateFormat('HH:mm')
              .format((data['waktuAbsen'] as Timestamp).toDate());
        }
      }

      // Mengubah hasil groupedData ke dalam List dan memperbarui absensiList
      absensiList.value = groupedData.values.toList();
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }
}
