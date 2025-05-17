import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simawar/app/constants/const_color.dart';
import 'package:simawar/app/routes/app_pages.dart';

import '../../../data/models/order.dart';
import '../../../data/repository/auth_repository.dart';
import '../../../data/repository/order_repository.dart';
import '../../proses/controllers/proses_controller.dart';

class HomeController extends GetxController {
  final OrderRepository _orderRepository = OrderRepository();
  final AuthRepository _authRepository = AuthRepository();
  final ProsesController prosesController = Get.find<ProsesController>();

  var orders = <Order>[].obs;

  var userName = ''.obs;
  var userImage = ''.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var completedOrderCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
    fetchCompletedOrderCount();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('name') ?? '';
    userImage.value = prefs.getString('image') ?? '';
  }

  Future<void> fetchCompletedOrderCount() async {
    try {
      final response = await _orderRepository.getCompletedOrderCount();
      if (response['success'] == true) {
        completedOrderCount.value = response['total_completed_orders'] as int;
      } else {
        errorMessage.value =
            response['message'] ?? 'Gagal memuat jumlah order selesai';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat jumlah order selesai';
    }
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _orderRepository.getOrders();

      if (response["success"] == true) {
        final data = response["data"] as List;
        orders.assignAll(data.map((e) => Order.fromJson(e)).toList());
        errorMessage.value = ''; // Clear error message if success
      } else {
        orders.clear(); // Clear existing orders
        errorMessage.value = response["message"] ?? 'Gagal memuat order';
      }
    } catch (e) {
      orders.clear();
      errorMessage.value = 'Terjadi kesalahan saat memuat order: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> takeOrder(int orderId) async {
    try {
      isLoading.value = true;
      final response = await _orderRepository.takeOrder(orderId);

      if (response["success"] == true) {
        await fetchOrders(); // Refresh data setelah mengambil order
        await prosesController.fetchOrders();
        Get.snackbar(
          "Sukses",
          "Order berhasil diambil",
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          "Error",
          response["message"] ?? 'Order Sudah Diambil',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        'Terjadi kesalahan saat mengambil order: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
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
            // Tampilkan loading indicator
            Get.dialog(
              barrierColor: ConstColor.white,
              const Center(child: CircularProgressIndicator()),
              barrierDismissible: false,
            );

            // Panggil method logout
            final response = await _authRepository.logout();

            // Tutup loading indicator
            Get.back();

            // Periksa apakah key `success` ada dan bernilai true
            if (response['success'] == true) {
              // Redirect ke halaman login
              Get.offAllNamed(Routes.LOGIN);
            } else {
              // Tampilkan pesan error jika logout gagal
              Get.snackbar(
                'Error',
                response['message'] ?? 'Terjadi kesalahan saat logout',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
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
}
