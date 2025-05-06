import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simawar/app/constants/const_color.dart';
import 'package:simawar/app/data/utils/date_coverter.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, size: 22.sp, color: ConstColor.white),
        ),
        title: Text(
          'History Selesai',
          style: TextStyle(
            fontSize: 16.sp,
            color: ConstColor.white,
            fontFamily: 'SemiBold',
          ),
        ),
        centerTitle: true,
        backgroundColor: ConstColor.primaryColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.completedOrders.isEmpty) {
          return const Center(child: Text("Tidak ada pesanan selesai."));
        }

        return ListView.builder(
          padding: EdgeInsets.all(10.w),
          itemCount: controller.completedOrders.length,
          itemBuilder: (context, index) {
            final order = controller.completedOrders[index];
            return Card(
              elevation: 3,
              color: ConstColor.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(10.w),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    (order['images'] as List).isNotEmpty
                        ? order['images'][0]
                        : '',
                    width: 50.w,
                    height: 50.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported),
                  ),
                ),
                title: Text(
                  'Nama: ${order['name']}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tanggal Selesai: ${formatDate(order['updated_at'])}"),
                    Text("Status: ${order['status']}",
                        style: TextStyle(
                            color: order['status'] == "selesai"
                                ? Colors.green
                                : Colors.orange)),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
