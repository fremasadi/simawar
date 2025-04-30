import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/repository/auth_repository.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthRepository authRepository = AuthRepository();

  var isLoading = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus(); // Cek status login saat controller diinisialisasi
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return; // Stop kalau form tidak valid
    }

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    isLoading.value = true;
    final result = await authRepository.login(email, password);
    isLoading.value = false;

    if (result['success']) {
      Get.snackbar("Success", result['message']);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", result['token']);
      await prefs.setString("user", result['user'].toString());

      Get.offAllNamed(Routes.BASE);
    } else {
      Get.snackbar("Error", result['message']);
    }
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token != null) {
      Future.delayed(Duration.zero, () {
        Get.offAllNamed(Routes.BASE); // Navigate to home page jika sudah login
      });
    }
  }
}
