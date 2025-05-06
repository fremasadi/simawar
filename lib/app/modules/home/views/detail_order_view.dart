import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simawar/app/constants/const_color.dart';

import '../../../data/models/order.dart';
import '../controllers/home_controller.dart';

class DetailOrderView extends StatelessWidget {
  const DetailOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final Order order = Get.arguments['order'];
    final HomeController homeController = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, size: 28.sp),
        ),
        title: Text(
          "Detail Pesanan",
          style: TextStyle(fontSize: 16.sp),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          Obx(() {
            if (homeController.isLoading.value) {
              return Padding(
                padding: EdgeInsets.all(12.sp),
                child: CircularProgressIndicator(strokeWidth: 2.sp),
              );
            }
            return Container(
              decoration: BoxDecoration(
                color: ConstColor.primaryColor,
                borderRadius: BorderRadius.circular(12.sp),
              ),
              child: TextButton(
                onPressed: () async {
                  await homeController.takeOrder(order.id);
                },
                child: Text(
                  'Ambil',
                  style: TextStyle(fontSize: 14.sp, color: ConstColor.white),
                ),
              ),
            );
          }),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian Gambar
            _buildImageSection(order),
            SizedBox(height: 8.h),

            // Bagian Informasi Pesanan
            _buildOrderInfoSection(order),
            SizedBox(height: 8.h),

            // Bagian Detail Ukuran
            _buildSizeDetailSection(order),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(Order order) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(16.sp),
      child: Column(
        children: [
          SizedBox(
            height: 250.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: order.images.length,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                return Hero(
                  tag: 'order-${order.id}-img-$index',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.sp),
                    child: Image.network(
                      order.images[index],
                      width: 250.w,
                      height: 250.h,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 250.w,
                          height: 250.h,
                          color: Colors.grey[200],
                          child: Icon(Icons.broken_image,
                              size: 50.sp, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfoSection(Order order) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Informasi Pesanan"),
          SizedBox(height: 12.h),
          if (order.address.isNotEmpty)
            _buildInfoRow(
              icon: Icons.location_on_outlined,
              label: "Alamat",
              value: order.address,
            ),
          _buildInfoRow(
            icon: Icons.access_time,
            label: "Deadline",
            value: _formatDateTime(order.deadline),
            valueColor: Colors.redAccent,
          ),
          if (order.phone.isNotEmpty)
            _buildInfoRow(
              icon: Icons.phone_outlined,
              label: "No HP",
              value: order.phone,
            ),
          _buildInfoRow(
            icon: Icons.straighten,
            label: "Model Ukuran",
            value: order.sizeModel,
          ),
          _buildInfoRow(
            icon: Icons.shopping_bag_outlined,
            label: "Jumlah",
            value: "${order.quantity} item",
          ),
        ],
      ),
    );
  }

  Widget _buildSizeDetailSection(Order order) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Detail Ukuran"),
          SizedBox(height: 12.h),
          ...order.size.entries
              .map((e) => _buildSizeRow(e.key, e.value))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSizeRow(String key, dynamic value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
        crossAxisAlignment: CrossAxisAlignment.start,
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

  String _formatDateTime(String dateTime) {
    try {
      final parsedDate = DateTime.parse(dateTime);
      return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year} ${parsedDate.hour}:${parsedDate.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateTime; // Return original if parsing fails
    }
  }
}
