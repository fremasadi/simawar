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
              top: ConstSize.appBarHeight(), left: 20, right: 20),
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
                    decoration: BoxDecoration(
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
                        '${controller.getGreting()},fremas',
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
              Container(
                padding: EdgeInsets.all(8.sp),
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
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/ic_ordering.png',
                      width: 50.w,
                      height: 50.h,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No.244432',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'semiBold',
                            color: ConstColor.secondaryColor,
                          ),
                        ),
                        Text(
                          'Estimasi Selesai :',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ConstColor.black,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(6.sp),
                          decoration: BoxDecoration(
                            color: ConstColor.primaryColor,
                            borderRadius: BorderRadius.circular(16.sp),
                          ),
                          child: Text(
                            '29 September 2024 Pagi',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: ConstColor.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Get.to(DetailOrderView());
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
