import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simawar/app/constants/const_color.dart';
import 'package:simawar/app/constants/const_size.dart';
import 'package:simawar/app/modules/home/views/detail_order_view.dart';
import 'package:simawar/app/modules/home/views/history_view.dart';
import 'package:simawar/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: controller.fetchOrders,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          // penting agar bisa di-refresh

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
                    Obx(() {
                      return Container(
                        height: 40.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: controller.userImage.isNotEmpty
                                ? NetworkImage(controller.userImage.value)
                                : const AssetImage('assets/images/profile.png')
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'SemiBold',
                          ),
                        ),
                        Obx(() {
                          return Text(
                            controller.userName.isNotEmpty
                                ? controller.userName.value
                                : "Name",
                            style: TextStyle(fontSize: 12.sp),
                          );
                        }),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        controller.showLogoutConfirmationDialog();
                      },
                      child: Container(
                        padding: EdgeInsets.all(6.sp),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.logout,
                          size: 22.sp,
                          color: Colors.white,
                        ),
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
                          Obx(() {
                            return Text(
                              '${controller.completedOrderCount.value}',
                              style: TextStyle(
                                fontFamily: 'bold',
                                fontSize: 18.sp,
                                color: ConstColor.secondaryColor,
                              ),
                            );
                          }),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Get.to(const HistoryView());
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 24.sp,
                          color: ConstColor.white,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.sp),
                  margin: EdgeInsets.only(bottom: 8.sp),
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
                            'Data Penggajian',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Medium',
                              color: ConstColor.white,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Get.toNamed(Routes.SALARY);
                        },
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
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Tampilkan pesan error jika ada
                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.sp),
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(fontSize: 14.sp, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  if (controller.orders.isEmpty) {
                    return const Center(
                        child: Text("Tidal ada pesanan yang tersedia"));
                  }

                  return ListView.builder(
                    itemCount: controller.orders.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final order = controller.orders[index];

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
                                  order.sizeModel,
                                  // Menggunakan property dari model
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'semiBold',
                                    color: ConstColor.secondaryColor,
                                  ),
                                ),
                                SizedBox(height: 4.h),
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
                                      // Menggunakan property dari model
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
                                Get.to(() => const DetailOrderView(),
                                    arguments: {'order': order});
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
      ),
    );
  }
}
