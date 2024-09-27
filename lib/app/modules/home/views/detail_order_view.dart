import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simawar/app/constants/const_color.dart';

class DetailOrderView extends GetView {
  const DetailOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColor.backgroundColor,
        title: Text(
          'Detail Pesanan',
          style: TextStyle(fontSize: 16.sp, fontFamily: 'semiBold'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/icons/ic_baju.png',
                  width: context.width * .3,
                ),
              ),
              SizedBox(height: 20.h),
              ListView(
                shrinkWrap: true,
                // This allows ListView inside SingleChildScrollView
                physics: NeverScrollableScrollPhysics(),
                // Prevent inner scroll conflict
                children: [
                  buildSizeCard('Lingkar Dada', '90 cm'),
                  buildSizeCard('Lingkar Pinggang', '75 cm'),
                  buildSizeCard('Lingkar Pinggul', '95 cm'),
                  buildSizeCard('Lebar Bahu', '40 cm'),
                  buildSizeCard('Panjang Lengan', '60 cm'),
                  buildSizeCard('Panjang Baju', '70 cm'),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 50.sp),
                decoration: BoxDecoration(
                  color: ConstColor.primaryColor,
                  borderRadius: BorderRadius.circular(16.sp),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Ambil Pesanan',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'semiBold',
                      color: ConstColor.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSizeCard(String title, String value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ConstColor.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
