import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:simawar/app/constants/const_color.dart';
import 'package:simawar/app/constants/const_size.dart';
import 'package:simawar/app/modules/base/views/base_view.dart';
import 'package:simawar/app/modules/home/views/detail_order_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: ConstSize.appBarHeight(), left: 16.sp, right: 16.sp),
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
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/images/profile.png',
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${controller.getGreeting()},pigo',
                        style: TextStyle(
                          fontFamily: 'semiBold',
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        'Karyawan outlet 01',
                        style: TextStyle(
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.all(6.sp),
                    margin: EdgeInsets.only(right: 6.sp),
                    decoration: BoxDecoration(
                      color: ConstColor.primaryColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.settings,
                      size: 22.sp,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.sp),
                    decoration: BoxDecoration(
                      color: ConstColor.primaryColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.logout,
                      size: 22.sp,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(16.sp),
                margin: EdgeInsets.symmetric(vertical: 12.sp),
                decoration: BoxDecoration(
                  color: ConstColor.primaryColor,
                  borderRadius: BorderRadius.circular(16.sp),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/ic_history.png',
                      width: 50.w,
                      height: 50.h,
                      color: ConstColor.white,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'History Selesai',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Medium',
                            color: ConstColor.white,
                          ),
                        ),
                        Text(
                          '12',
                          style: TextStyle(
                            fontFamily: 'bold',
                            fontSize: 18.sp,
                            color: ConstColor.secondaryColor,
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 24.sp,
                        color: ConstColor.white,
                      ),
                    )
                  ],
                ),
              ),
              Text(
                'Pekerjaan yang tersedia',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'semiBold',
                ),
              ),
              Obx(() {
                if (controller.hasPendingOrder.value) {
                  return Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Mohon Maaf selesaikan Perkejaan Anda "
                      "Dan Jika sudah Selesai Dan Dikonfirmasi Admin Maka Akan "
                      "Bisa Ngambil Job Lagi",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                if (controller.orders.isEmpty) {
                  return const Center(child: Text("Tidak ada pesanan."));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  // Tambahkan ini untuk mencegah overflow
                  physics: const NeverScrollableScrollPhysics(),
                  // Nonaktifkan scroll pada ListView
                  itemCount: controller.orders.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    var order = controller.orders[index];

                    return Container(
                      padding: EdgeInsets.all(8.sp),
                      margin: EdgeInsets.symmetric(vertical: 8.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.sp),
                        color: ConstColor.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/ic_ordering.png',
                            width: 50.w,
                            height: 50.h,
                          ),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.getItemTypeString(order.type),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: 'semiBold',
                                  color: ConstColor.secondaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Deadline : ',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: ConstColor.black,
                                    ),
                                  ),
                                  Text(
                                    order.deadline,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: ConstColor.primaryColor,
                                      fontFamily: 'semiBold',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Get.to(() => DetailOrderView(),
                                  arguments: {'order': order.toMap()});
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                            ),
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
