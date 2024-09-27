import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:simawar/app/constants/const_size.dart';

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
              Container(
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                        Text(
                          'No.244432',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'semiBold',
                            color: ConstColor.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: Text(
                            'Selesaikan',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'semiBold',
                              color: ConstColor.white,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: ConstColor.accentColor,
                            borderRadius: BorderRadius.circular(16.sp),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 4.5.sp, horizontal: 12.sp),
                        ),
                      ],
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
