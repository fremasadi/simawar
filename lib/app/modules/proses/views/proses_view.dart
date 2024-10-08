import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simawar/app/constants/const_size.dart';
import 'package:simawar/app/modules/proses/views/detail_img_view.dart';

import '../../../constants/const_color.dart';
import '../controllers/proses_controller.dart';

class ProsesView extends GetView<ProsesController> {
  const ProsesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: ConstSize.appBarHeight(),
            left: 20.sp,
            right: 20.sp,
          ),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/img_logo.png',
                  width: context.width * .4,
                  height: context.height * .1,
                ),
              ),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.orders.isEmpty) {
                  return const Center(child: Text("Tidak ada pesanan."));
                }
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.orders.length,
                  itemBuilder: (context, index) {
                    var order = controller.orders[index];
                    return Container(
                      padding: EdgeInsets.all(16.sp),
                      margin: EdgeInsets.symmetric(vertical: 12.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.sp),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama Pemesan : ${order.name}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: ConstColor.primaryColor,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Estimasi Selesai : ',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: ConstColor.black,
                                ),
                              ),
                              Text(
                                order.deadline,
                                // Ganti ini dengan deadline order
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ConstColor.secondaryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          GestureDetector(
                            onTap: () {
                              Get.to(DetailImgView(),
                                  arguments: {'imgUrl': order.imgUrl});
                            },
                            child: Image.network(
                              order.imgUrl,
                              width: double.infinity,
                              height: context.height * .5,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Ukuran:',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: ConstColor.black,
                            ),
                          ),
                          for (var entry in order.sizes.entries)
                            Text(
                              '${entry.key} : ${entry.value}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: ConstColor.black,
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
