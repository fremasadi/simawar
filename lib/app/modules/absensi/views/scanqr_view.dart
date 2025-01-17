import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
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
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: ConstColor.primaryColor, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const Positioned.fill(
            child: ScannerOverlay(),
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
          hasScanned = true;
        });
        _processQRCode(scanData.code!);
      }
    });
  }

  Future<void> _processQRCode(String qrCode) async {
    try {
      final parts = qrCode.split('|');
      final user = FirebaseAuth.instance.currentUser;

      if (parts.length == 2 && parts[0] == 'ABSEN_MASUK') {
        final timestamp = DateTime.parse(parts[1]);

        if (user != null) {
          // Mengambil awal hari (midnight) dari waktu absen untuk membandingkan dengan Firestore
          final startOfDay =
              DateTime(timestamp.year, timestamp.month, timestamp.day);

          // Query untuk memeriksa apakah absen masuk sudah ada untuk user pada hari ini
          final absensiMasukQuery = await FirebaseFirestore.instance
              .collection('absensi')
              .where('userId', isEqualTo: user.uid)
              .where('tipeAbsen', isEqualTo: 'Masuk')
              .where('waktuAbsen', isGreaterThanOrEqualTo: startOfDay)
              .get();

          if (absensiMasukQuery.docs.isNotEmpty) {
            // Jika sudah ada absen masuk hari ini
            Get.snackbar(
                'Sudah Absen', 'Anda sudah melakukan absen masuk hari ini');
          } else {
            // Jika belum ada, tambahkan data absen masuk ke Firestore
            await FirebaseFirestore.instance.collection('absensi').add({
              'userId': user.uid,
              'waktuAbsen': timestamp,
              'tipeAbsen': 'Masuk',
              'waktuScan': FieldValue.serverTimestamp(),
            });
            Get.snackbar('Sukses', 'Absensi masuk berhasil dicatat');
          }
        } else {
          Get.snackbar('Error', 'Pengguna tidak terautentikasi');
        }
      } else {
        Get.snackbar('Error',
            'Format QR Code tidak valid atau bukan untuk absensi masuk');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      // Reset scanner setelah 3 detik
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          hasScanned = false;
          qrData = null;
        });
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.5),
        BlendMode.srcOut,
      ),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              backgroundBlendMode: BlendMode.dstOut,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
