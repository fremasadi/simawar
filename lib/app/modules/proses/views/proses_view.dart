import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simawar/app/constants/const_size.dart';
import 'package:simawar/app/modules/proses/views/detail_img_view.dart';
import '../../../constants/const_color.dart';
import '../controllers/proses_controller.dart';

class ProsesView extends StatelessWidget {
  const ProsesView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProsesController controller = Get.put(ProsesController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: ConstSize.appBarHeight(),
            left: 16.sp,
            right: 16.sp,
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
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .3,
                      ),
                      child: const Text(
                        "Tidak ada pesanan yang sedang dikerjakan Silakan ambil pesanan.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
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
                            'Nama Pemesan : ${order["name"]}',
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
                                order["deadline"] ?? "-",
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
                              Get.to(
                                () => DetailImgView(),
                                arguments: {
                                  'images': order["images"],
                                  'initialIndex': 0,
                                },
                              );
                            },
                            child: Image.network(
                              (order["images"] as List).isNotEmpty
                                  ? order["images"][0]
                                  : "",
                              width: double.infinity,
                              height: context.height * .5,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                            padding: EdgeInsets.all(16.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle("Detail Ukuran"),
                                ...order['size'].entries.map<Widget>((e) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 4.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          e.key,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          '${e.value} cm',
                                          style: TextStyle(
                                            fontSize: 14.sp,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
