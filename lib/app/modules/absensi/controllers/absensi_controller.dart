import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AbsensiController extends GetxController {
  var absensiList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var selectedMonth = DateTime.now().month.obs; // Menyimpan bulan yang dipilih

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    listenToAbsensiData();
  }

  // Fungsi untuk mengambil data absensi berdasarkan bulan
  void listenToAbsensiData() {
    final user = _auth.currentUser;
    if (user == null) {
      // Handle jika user tidak ditemukan (misalnya belum login)
      return;
    }
    final userId = user.uid;

    // Mendapatkan tanggal awal dan akhir bulan berdasarkan bulan yang dipilih
    DateTime firstDayOfMonth = DateTime(DateTime.now().year, selectedMonth.value, 1);
    DateTime lastDayOfMonth = DateTime(DateTime.now().year, selectedMonth.value + 1, 0, 23, 59, 59);

    // Mendapatkan stream dari query Firestore berdasarkan userId dan filter bulan
    _firestore
        .collection('absensi')
        .where('userId', isEqualTo: userId)
        .where('waktuAbsen', isGreaterThanOrEqualTo: firstDayOfMonth)
        .where('waktuAbsen', isLessThanOrEqualTo: lastDayOfMonth)
        .orderBy('waktuAbsen', descending: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (snapshot.docs.isEmpty) {
        // Jika data kosong, bisa ditangani di sini
        absensiList.clear();
      } else {
        // Memproses data absensi dan mengelompokkan berdasarkan tanggal
        Map<String, Map<String, dynamic>> groupedData = {};

        for (var doc in snapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;

          var tanggal = DateFormat('yyyy-MM-dd')
              .format((data['waktuAbsen'] as Timestamp).toDate());

          if (!groupedData.containsKey(tanggal)) {
            groupedData[tanggal] = {
              'tanggal': tanggal,
              'Masuk': '-',
            };
          }

          if (data['tipeAbsen'] == 'Masuk') {
            groupedData[tanggal]!['Masuk'] = DateFormat('HH:mm')
                .format((data['waktuAbsen'] as Timestamp).toDate());
          }
          // Bagian untuk tipe absen 'Keluar' telah dihapus
        }

        // Mengubah hasil groupedData ke dalam List dan memperbarui absensiList
        absensiList.value = groupedData.values.toList();
      }
    });
  }

  // Fungsi untuk mengganti bulan yang dipilih
  void changeMonth(int month) {
    selectedMonth.value = month;
    listenToAbsensiData(); // Memanggil ulang fungsi untuk menampilkan data sesuai bulan yang dipilih
  }
}
