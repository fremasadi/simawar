import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simawar/app/constants/const_color.dart';
import 'package:simawar/app/modules/home/controllers/detail_order_controller.dart';

class DetailOrderView extends GetView<DetailOrderController> {
  const DetailOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> order = Get.arguments['order'];

    final String orderId = order['id'] ?? '';
    final String dateline = order['deadline'] ?? '';
    final String imgUrl = order['imgUrl'] ?? '';
    final Map<String, dynamic> sizes = order['sizes'] ?? {};
    print('object $imgUrl');

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
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.sp),
                  image: DecorationImage(image: NetworkImage(imgUrl),fit: BoxFit.fill)
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Deadline $dateline',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14.sp),),
              ),
              ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                children: sizes.entries.map((entry) {
                  return buildSizeCard(entry.key, entry.value?.toString() ?? 'N/A');
                }).toList(),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16.sp),
                decoration: BoxDecoration(
                  color: ConstColor.primaryColor,
                  borderRadius: BorderRadius.circular(16.sp),
                ),
                child: TextButton(
                  onPressed: () {
                    controller.assignOrder(orderId);
                  },
                  child: Text(
                    'Ambil Pesanan',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'semiBold',
                      color: ConstColor.white,
                    ),
                  ),
                ),
              ),
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
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
