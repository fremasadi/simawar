import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simawar/main.dart';
import '../../../constants/const_color.dart';
import '../../absensi/views/absensi_view.dart';
import '../../home/views/home_view.dart';
import '../../proses/views/proses_view.dart';
import '../controllers/base_controller.dart';

class BaseView extends GetView<BaseController> {
  const BaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: const [
              HomeView(),
              AbsensiView(),
              ProsesView(),
            ],
          )),
      bottomNavigationBar: Obx(() => ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), // Tambahkan border radius di sini
              topRight: Radius.circular(20),
            ),
            child: BottomNavigationBar(
              currentIndex: controller.selectedIndex.value,
              onTap: controller.onItemTapped,
              selectedFontSize: 14.sp,
              unselectedFontSize: 14.sp,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.dashboard,
                    size: 36.sp,
                  ),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.calendar_month,
                    size: 36.sp,
                  ),
                  label: 'Absensi',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.sync_sharp,
                    size: 36.sp,
                  ),
                  label: 'Proses',
                ),
              ],
              selectedItemColor: ConstColor.secondaryColor,
              // Warna ketika aktif
              unselectedItemColor: ConstColor.white,
              // Warna ketika inaktif
              backgroundColor: ConstColor.primaryColor, // Warna background
            ),
          )),
    );
  }
}
