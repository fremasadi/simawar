import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simawar/app/constants/const_color.dart';
import 'package:simawar/app/modules/absensi/controllers/absensi_controller.dart';
import 'package:simawar/app/modules/absensi/views/scanqr_view.dart';

import '../../../constants/const_size.dart';

class AbsensiView extends GetView<AbsensiController> {
  const AbsensiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        padding: EdgeInsets.all(12.sp),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ConstColor.primaryColor,
        ),
        child: IconButton(
          onPressed: () {
            // Arahkan ke halaman Scan QR
            Get.to(() => const ScanQrView());
          },
          icon: Icon(
            Icons.camera_alt,
            size: 28.sp,
            color: ConstColor.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: ConstSize.appBarHeight(),
            left: 16.sp,
            right: 16.sp,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/img_logo.png',
                  width: context.width * .4,
                  height: context.height * .1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  children: [
                    Text(
                      'Riwayat Absen Bulan Ini',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'semiBold',
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.calendar_month,
                        size: 22.sp,
                        color: ConstColor.errorColor,
                      ),
                    )
                  ],
                ),
              ),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.absensiList.isEmpty) {
                  return const Center(child: Text('Tidak ada data absensi'));
                }

                return GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Jumlah kolom dalam grid
                    crossAxisSpacing: 8.sp,
                    mainAxisSpacing: 8.sp,
                    childAspectRatio: 1.5, // Rasio ukuran grid
                  ),
                  itemCount: controller.absensiList.length,
                  itemBuilder: (context, index) {
                    final data = controller.absensiList[index];

                    final tanggal = data['tanggal'];
                    final waktuMasuk = data['Masuk'] ?? '-';

                    return Container(
                      padding: EdgeInsets.all(16.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.sp),
                        color: Colors.blue.withOpacity(0.3),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                tanggal,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12.sp,
                                  fontFamily: 'semiBold',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 22.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Status',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: 'semiBold',
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    'Jam Hadir',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hadir',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: 'semiBold',
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    waktuMasuk,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
