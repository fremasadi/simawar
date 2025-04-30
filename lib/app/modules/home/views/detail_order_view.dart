import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simawar/app/constants/const_color.dart';

import '../controllers/home_controller.dart';

class DetailOrderView extends StatelessWidget {
  const DetailOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> order = Get.arguments['order'];
    final HomeController homeController = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Pesanan",
          style: TextStyle(fontSize: 16.sp),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          Container(
            decoration: BoxDecoration(
              color: ConstColor.primaryColor,
              borderRadius: BorderRadius.circular(12.sp),
            ),
            child: TextButton(
                onPressed: () async {
                  await homeController.takeOrder(order['id']);
                  Get.back(); // Kembali ke halaman sebelumnya setelah order diambil
                },
                child: Text(
                  'Ambil',
                  style: TextStyle(fontSize: 14.sp, color: ConstColor.white),
                )),
          )
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(16.sp),
              child: Column(
                children: [
                  Hero(
                    tag: 'order-${order['id']}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.sp),
                      child: Image.network(
                        order['image'],
                        width: 250.w,
                        height: 250.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image,
                              size: 100.w, color: Colors.grey);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Informasi Pesanan"),
                  SizedBox(height: 12.h),
                  // _buildInfoRow(
                  //   icon: Icons.location_on_outlined,
                  //   label: "Alamat",
                  //   value: order['address'],
                  // ),
                  _buildInfoRow(
                    icon: Icons.access_time,
                    label: "Deadline",
                    value: order['deadline'],
                    valueColor: Colors.redAccent,
                  ),
                  // _buildInfoRow(
                  //   icon: Icons.phone_outlined,
                  //   label: "No HP",
                  //   value: order['phone'],
                  // ),
                  _buildInfoRow(
                    icon: Icons.straighten,
                    label: "Model Ukuran",
                    value: order['size_model'],
                  ),
                  _buildInfoRow(
                    icon: Icons.shopping_bag_outlined,
                    label: "Jumlah",
                    value: "${order['quantity']} item",
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Detail Ukuran"),
                  SizedBox(height: 12.h),
                  ...order['size'].entries.map<Widget>((e) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.key,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            e.value.toString(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: Colors.grey[600]),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
