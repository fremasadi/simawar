import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:simawar/app/data/repository/attendance_repository.dart';

import '../views/scanqr_view.dart';

class AbsensiController extends GetxController {
  final AttendanceRepository _attendanceRepository = AttendanceRepository();

  // Scanner controller
  MobileScannerController? scannerController;

  var attendanceHistory = [].obs;
  var isLoadingAttendance = true.obs;

  // Variabel untuk menangani hasil scan QR
  var scanResult = 'Belum scan QR Code'.obs;
  var isLoading = false.obs;
  var isSuccess = false.obs;
  var message = ''.obs;

  // Variabel untuk filter tanggal
  var selectedFilter = 'Minggu Ini'.obs; // Default filter
  DateTime? startDate;
  DateTime? endDate;

  @override
  void onInit() {
    super.onInit();
    fetchAttendanceHistory();
  }

  @override
  void onClose() {
    scannerController?.dispose();
    super.onClose();
  }

  // Method untuk mengambil riwayat absensi dengan filter
  Future<void> fetchAttendanceHistory() async {
    isLoadingAttendance(true);

    // Set tanggal berdasarkan filter yang dipilih
    final now = DateTime.now();
    switch (selectedFilter.value) {
      case 'Minggu Ini':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        endDate = now.add(Duration(days: 7 - now.weekday));
        break;
      case 'Bulan Ini':
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0);
        break;
      case 'Custom':
        // Biarkan startDate dan endDate sesuai dengan input pengguna
        break;
      default:
        startDate = null;
        endDate = null;
    }

    // Format tanggal ke string (yyyy-MM-dd)
    final formattedStartDate = startDate?.toIso8601String().split('T').first;
    final formattedEndDate = endDate?.toIso8601String().split('T').first;

    // Panggil repository dengan filter tanggal
    final response = await _attendanceRepository.getAttendanceHistory(
      startDate: formattedStartDate,
      endDate: formattedEndDate,
    );

    if (response['message'] == "Riwayat absensi ditemukan!") {
      attendanceHistory.value = response['data'];
    }
    isLoadingAttendance(false);
  }

  // Method untuk mengubah filter
  void changeFilter(String filter) {
    selectedFilter.value = filter;
    fetchAttendanceHistory(); // Ambil data baru berdasarkan filter
  }

  // Method untuk mengatur tanggal custom
  void setCustomDateRange(DateTime start, DateTime end) {
    startDate = start;
    endDate = end;
    selectedFilter.value = 'Custom';
    fetchAttendanceHistory(); // Ambil data baru berdasarkan tanggal custom
  }

  void initScanner() {
    // Buat controller baru jika belum ada atau sudah didispose
    scannerController ??= MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  void stopScanner() {
    if (scannerController != null) {
      scannerController!.dispose();
      scannerController = null;
    }
  }

  // Method untuk membuka halaman scanner QR
  void openQRScanner() {
    Get.to(() => ScanQrView());
  }

  // Method baru untuk memproses QR Code yang dideteksi
  Future<void> processQrCode(String barcode) async {
    if (barcode.isEmpty) {
      scanResult.value = 'QR Code tidak valid';
      return;
    }

    try {
      isLoading.value = true;
      scanResult.value = 'Memproses QR Code...';

      // Memanggil repository untuk check-in
      final result = await _attendanceRepository.checkInAttendance(barcode);

      // Log seluruh respons untuk debugging
      debugPrint("RESPONSE CHECK-IN: $result");
      debugPrint("MESSAGE TYPE: ${result['message'].runtimeType}");
      debugPrint("MESSAGE VALUE: ${result['message']}");

      // Solusi 1: Anggap selalu sukses jika ada pesan "Absensi berhasil!"
      bool success = result['message'] == "Absensi berhasil!";

      // Log status sukses untuk debugging
      debugPrint("SUCCESS STATUS: $success");

      isLoading.value = false;
      isSuccess.value = success;
      message.value = result['message'] ?? 'Tidak ada pesan';
      scanResult.value = barcode;

      // Menampilkan notifikasi hasil check-in dengan pesan yang sebenarnya dari API
      Get.snackbar(
        success ? 'Berhasil' : 'Gagal',
        result['message'] ?? 'Tidak ada pesan',
        backgroundColor: success ? Colors.green : Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );

      // Refresh history setelah check-in
      await fetchAttendanceHistory();
    } catch (e) {
      debugPrint("ERROR: ${e.toString()}");
      scanResult.value = 'Error: ${e.toString()}';
      isSuccess.value = false;
      isLoading.value = false;
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Metode lama tetap dipertahankan untuk backward compatibility
  Future<void> scanQR() async {
    // Pindah ke halaman scanner
    openQRScanner();
  }
}
