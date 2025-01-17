import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simawar/app/constants/const_color.dart';

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

  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName') ??
        'Guest'; // Mengembalikan 'Guest' jika tidak ada nama yang disimpan
  }

  // Fungsi untuk mendapatkan sapaan berdasarkan waktu
  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return "Selamat Pagi";
    } else if (hour < 14) {
      return "Selamat Siang";
    } else if (hour < 18) {
      return "Selamat Sore";
    } else {
      return "Selamat Malam";
    }
  }

  // Method untuk mendapatkan item type dalam bentuk string
  String getItemTypeString(String itemType) {
    return itemType.toString().split('.').last;
  }

  Future<void> showLogoutConfirmationDialog() async {
    Get.defaultDialog(
      title: 'Konfirmasi Logout',
      titleStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: ConstColor.primaryColor,
      ),
      middleText: 'Apakah Anda yakin ingin keluar?',
      middleTextStyle: TextStyle(
        fontSize: 16.sp,
        color: Colors.grey[800],
      ),
      backgroundColor: Colors.white,
      radius: 12,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 20.sp),
      titlePadding: EdgeInsets.only(top: 24.sp, bottom: 8.sp),

      // Custom buttons dengan layout yang lebih baik
      cancel: SizedBox(
        width: 100.w,
        child: TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12.sp),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Text(
            'Tidak',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16.sp,
            ),
          ),
        ),
      ),

      confirm: SizedBox(
        width: 100.w,
        child: ElevatedButton(
          onPressed: () async {
            await logout();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ConstColor.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 12.sp),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: Text(
            'Ya',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk logout pengguna
  Future<void> logout() async {
    try {
      await _auth.signOut();
      // Arahkan ke halaman login setelah logout
      Get.offAllNamed(
          '/login'); // Pastikan rute '/login' telah diatur di aplikasi Anda
    } catch (e) {
      Get.snackbar(
        'Logout Gagal',
        'Terjadi kesalahan saat logout. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
