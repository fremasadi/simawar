import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:simawar/app/modules/absensi/controllers/absensi_controller.dart';

// Pastikan untuk import konstanta warna dan responsivitas jika diperlukan
// import 'package:simawar/app/core/values/colors.dart';
// import 'package:simawar/app/core/utils/size_ext.dart';

class ScanQrView extends StatefulWidget {
  const ScanQrView({Key? key}) : super(key: key);

  @override
  State<ScanQrView> createState() => _ScanQrViewState();
}

class _ScanQrViewState extends State<ScanQrView> {
  final AbsensiController controller = Get.find<AbsensiController>();
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
// Inisialisasi scanner controller
    controller.initScanner();
  }

  @override
  void dispose() {
// Controller akan dihandle oleh GetX lifecycle
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Absensi'),
        actions: [
          IconButton(
            icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() {
                _flashOn = !_flashOn;
                controller.scannerController?.toggleTorch();
              });
            },
          ),
        ],
      ),
      body: Obx(() {
        return Stack(
          children: [
// Scanner
            if (!controller.isLoading.value &&
                controller.scannerController != null)
              MobileScanner(
                controller: controller.scannerController!,
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty && barcodes[0].rawValue != null) {
// Stop scanner setelah mendeteksi QR
                    controller.scannerController?.stop();
// Proses QR yang terdeteksi
                    controller.processQrCode(barcodes[0].rawValue!);
// Kembali ke halaman sebelumnya setelah berhasil memproses
                    Future.delayed(const Duration(seconds: 2), () {
                      Get.back();
                    });
                  }
                },
              ),

// Loading indicator
            if (controller.isLoading.value)
              const Center(
                child: CircularProgressIndicator(),
              ),

// Scanner overlay
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

// Hasil scan & pesan
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.message.value.isNotEmpty
                          ? controller.message.value
                          : 'Arahkan kamera ke QR Code',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    if (controller.isSuccess.value)
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 40),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
