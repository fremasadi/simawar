import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simawar/app/constants/const_color.dart';
import 'package:simawar/app/modules/absensi/controllers/absensi_controller.dart';
import 'package:simawar/app/modules/absensi/views/add_izin_view.dart';

class AbsensiView extends GetView<AbsensiController> {
  const AbsensiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // GestureDetector(
          //   onTap: () {
          //     Get.to(AddIzinView());
          //   },
          //   child: Container(
          //     margin: EdgeInsets.only(right: 12.sp),
          //     padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
          //     decoration: BoxDecoration(
          //       color: ConstColor.primaryColor,
          //       borderRadius: BorderRadius.circular(12.sp),
          //     ),
          //     child: Text(
          //       'Tambah Izin',
          //       style: TextStyle(
          //         fontSize: 12.sp,
          //         color: ConstColor.white,
          //         fontFamily: 'SemiBold',
          //       ),
          //     ),
          //   ),
          // ),
          Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.sp),
              color: ConstColor.primaryColor,
            ),
            child: GestureDetector(
              onTap: () {
                controller.openQRScanner(); // Gunakan method baru
              },
              child: Icon(
                Icons.camera_alt,
                size: 28.sp,
                color: ConstColor.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().statusBarHeight,
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
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  children: [
                    Obx(() => Text(
                          'Riwayat ${controller.selectedFilter.value}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'semiBold',
                          ),
                        )),
                    IconButton(
                      onPressed: () {
                        // Tampilkan dialog untuk memilih filter
                        showFilterDialog(context);
                      },
                      icon: Icon(
                        Icons.calendar_month,
                        size: 22.sp,
                        color: ConstColor.errorColor,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                if (controller.isLoadingAttendance.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.attendanceHistory.isEmpty) {
                  return const Center(child: Text('Tidak ada data absensi'));
                }

                return GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.sp,
                    mainAxisSpacing: 8.sp,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: controller.attendanceHistory.length,
                  itemBuilder: (context, index) {
                    final data = controller.attendanceHistory[index];
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
                                '${data['date']}',
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
                                  if (data['status'] == 'hadir')
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
                                    '${data['status']}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: 'semiBold',
                                      color: Colors.blue,
                                    ),
                                  ),
                                  if (data['status'] == 'hadir')
                                    Text(
                                      '${data['check_in']}',
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

  // Dialog untuk memilih filter
  void showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pilih Filter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Minggu Ini'),
                onTap: () {
                  controller.changeFilter('Minggu Ini');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Bulan Ini'),
                onTap: () {
                  controller.changeFilter('Bulan Ini');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Custom'),
                onTap: () async {
                  Navigator.pop(context);
                  final DateTimeRange? picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    controller.setCustomDateRange(picked.start, picked.end);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
