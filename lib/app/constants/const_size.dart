import 'package:flutter/material.dart';

class ConstSize {
  // Mendapatkan tinggi status bar
  static double statusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  // Mendapatkan tinggi layar
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Mendapatkan lebar layar
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Ukuran font berdasarkan lebar layar (kamu bisa menyesuaikan formula sesuai kebutuhan)
  static double fontSizeSmall(BuildContext context) {
    return screenWidth(context) * 0.04; // Contoh kecil
  }

  static double fontSizeMedium(BuildContext context) {
    return screenWidth(context) * 0.05; // Contoh sedang
  }

  static double fontSizeLarge(BuildContext context) {
    return screenWidth(context) * 0.06; // Contoh besar
  }

  // Mendapatkan tinggi AppBar secara default
  static double appBarHeight() {
    return AppBar().preferredSize.height;
  }
}