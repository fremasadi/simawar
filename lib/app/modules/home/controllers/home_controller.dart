import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simawar/app/constants/const_color.dart';
import 'package:simawar/app/routes/app_pages.dart';

import '../../../data/repository/auth_repository.dart';
import '../../../data/repository/order_repository.dart';
import '../../../data/repository/user_repository.dart'; // Import model Pesanan

class HomeController extends GetxController {
  final OrderRepository _orderRepository = OrderRepository();
  final UserRepository _userRepository = UserRepository();
  final AuthRepository _authRepository = AuthRepository();

  var orders = <Map<String, dynamic>>[].obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userImage = ''.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var completedOrderCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
    fetchUserProfile();
    fetchCompletedOrderCount();
  }

  Future<void> fetchUserProfile() async {
    isLoading(true);
    final response = await _userRepository.getUserProfile();
    if (response['success'] == true) {
      userName.value = response['data']['name'];
      userEmail.value = response['data']['email'];
      userImage.value = response['data']['image'];
    }
    isLoading(false);
  }

  Future<void> fetchCompletedOrderCount() async {
    final response = await _orderRepository.getCompletedOrderCount();
    if (response['success'] == true) {
      completedOrderCount.value = response['total_completed_orders'];
    }
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await _orderRepository.getOrders();

    if (response["success"] == true) {
      orders.value = List<Map<String, dynamic>>.from(response["data"]);
    } else {
      errorMessage.value = response["message"];
    }

    isLoading.value = false;
  }

  Future<void> takeOrder(int orderId) async {
    isLoading.value = true;

    final response = await _orderRepository.takeOrder(orderId);

    if (response["success"] == true) {
      fetchOrders(); // Refresh daftar orders setelah berhasil mengambil order
      Get.snackbar("Sukses", "Order berhasil diambil");
      Get.back();
    } else {
      Get.snackbar("Error", response["message"]);
    }

    isLoading.value = false;
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
