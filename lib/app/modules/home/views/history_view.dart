import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simawar/app/constants/const_color.dart';

class HistoryView extends GetView {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 22.sp,
              color: ConstColor.white,
            )),
        title: Text(
          'History Selesai',
          style: TextStyle(
              fontSize: 16.sp, color: ConstColor.white, fontFamily: 'SemiBold'),
        ),
        centerTitle: true,
        backgroundColor: ConstColor.primaryColor,
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              'HistoryView is working',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
