import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final isLoading = false.obs; // Menambahkan RxBool untuk status loading

  // Function to login
  Future<void> login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists && userDoc['role'] == 'karyawan') {
        // Ambil nama pengguna dari dokumen Firestore
        String userName = userDoc['name'];

        // Simpan nama pengguna ke SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', userName);

        isLoading.value = true; // Mengaktifkan status loading
        await Future.delayed(
            const Duration(seconds: 2)); // Simulasi proses login

        // Navigasi ke halaman utama setelah login
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed(Routes.BASE); // Navigate to home page
        });
      } else {
        Get.snackbar('Maaf', 'Login gagal');
      }
    } catch (e) {
      Get.snackbar('Login Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void checkLoginStatus() {
    User? user = _auth.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(Routes.BASE); // Navigate to home page
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Check if user is already logged in when the controller is initialized
    checkLoginStatus();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
