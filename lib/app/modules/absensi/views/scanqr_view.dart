import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simawar/app/constants/const_color.dart';

class ScanQrView extends StatefulWidget {
  const ScanQrView({super.key});

  @override
  _ScanQrViewState createState() => _ScanQrViewState();
}

class _ScanQrViewState extends State<ScanQrView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrData;
  bool hasScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // QR scanner view
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          // Overlay for the scanning box in the center
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: ConstColor.primaryColor, width: 4),
                // Kotak hijau
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Overlay to dim the screen except for the scanning box
          Positioned.fill(
            child:
                ScannerOverlay(), // Custom overlay to make surrounding areas dimmed
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!hasScanned) {
        setState(() {
          qrData = scanData.code;
          hasScanned = true; // Menghindari scanning berulang kali
        });
        _processQrData(scanData.code);
      }
    });
  }

  Future<void> _processQrData(String? code) async {
    if (code == null) {
      Get.snackbar(
        backgroundColor: ConstColor.errorColor,
        'QR Code Salah',
        'QR Code tidak valid untuk absensi',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(now);

        final absensiRef = FirebaseFirestore.instance
            .collection('absensi')
            .doc(userId)
            .collection('absensiHarian');

        // Cek apakah user sudah absen hadir atau keluar hari ini
        final querySnapshot =
            await absensiRef.where('tanggal', isEqualTo: formattedDate).get();

        if (code.startsWith('Hadir')) {
          // Handle Absen Hadir
          if (querySnapshot.docs.isNotEmpty &&
              querySnapshot.docs.first['status'] == 'hadir') {
            Get.snackbar(
              backgroundColor: ConstColor.successColor,
              'Sudah Absen',
              'Anda sudah absen hadir hari ini!',
              snackPosition: SnackPosition.TOP,
            );
          } else {
            await absensiRef.add({
              'status': 'hadir',
              'tanggal': formattedDate,
              'waktu': FieldValue.serverTimestamp(),
            });
            Get.snackbar(
              backgroundColor: ConstColor.successColor,
              'Berhasil',
              'Absensi masuk berhasil disimpan!',
              snackPosition: SnackPosition.TOP,
            );
          }
        } else if (code.startsWith('Keluar')) {
          // Handle Absen Keluar
          if (querySnapshot.docs.isEmpty ||
              querySnapshot.docs.first['status'] != 'hadir') {
            Get.snackbar(
              backgroundColor: ConstColor.errorColor,
              'Gagal',
              'Anda belum absen hadir hari ini!',
              snackPosition: SnackPosition.TOP,
            );
          } else if (querySnapshot.docs.first['status'] == 'keluar') {
            Get.snackbar(
              backgroundColor: ConstColor.successColor,
              'Sudah Absen Keluar',
              'Anda sudah absen keluar hari ini!',
              snackPosition: SnackPosition.TOP,
            );
          } else {
            await absensiRef.add({
              'status': 'keluar',
              'tanggal': formattedDate,
              'waktu': FieldValue.serverTimestamp(),
            });
            Get.snackbar(
              backgroundColor: ConstColor.successColor,
              'Berhasil',
              'Absensi keluar berhasil disimpan!',
              snackPosition: SnackPosition.TOP,
            );
          }
        } else {
          Get.snackbar(
            backgroundColor: ConstColor.errorColor,
            'QR Code Salah',
            'QR Code tidak valid untuk absensi',
            snackPosition: SnackPosition.TOP,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        backgroundColor: ConstColor.errorColor,
        'Gagal',
        'Terjadi kesalahan saat menyimpan absensi: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class ScannerOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).size.height / 2 + 150,
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        // Bottom overlay
        Positioned(
          top: MediaQuery.of(context).size.height / 2 + 150,
          // Di bawah kotak QR
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(color: Colors.black.withOpacity(0.5)),
        ),
        // Left overlay
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 150,
          // Kiri kotak QR
          left: 0,
          right: MediaQuery.of(context).size.width / 2 + 150,
          bottom: MediaQuery.of(context).size.height / 2 - 150,
          child: Container(color: Colors.black.withOpacity(0.5)),
        ),
        // Right overlay
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 150,
          // Kanan kotak QR
          left: MediaQuery.of(context).size.width / 2 + 150,
          right: 0,
          bottom: MediaQuery.of(context).size.height / 2 - 150,
          child: Container(color: Colors.black.withOpacity(0.5)),
        ),
      ],
    );
  }
}
