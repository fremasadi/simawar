import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simawar/app/data/utils/date_coverter.dart';
import '../../../constants/const_color.dart';
import '../controllers/salary_controller.dart';
import 'package:intl/intl.dart';

class SalaryView extends GetView<SalaryController> {
  const SalaryView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.loadSalaryHistory();
    // Format mata uang
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, size: 22.sp, color: ConstColor.white),
        ),
        title: Text(
          'Penggajian',
          style: TextStyle(
            fontSize: 16.sp,
            color: ConstColor.white,
            fontFamily: 'SemiBold',
          ),
        ),
        centerTitle: false,
        actions: [
          // Dropdown Filter Status
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              icon: Icon(
                Icons.filter_alt,
                color: Colors.white,
                size: 28.sp,
              ),
              dropdownColor: ConstColor.primaryColor,
              style: const TextStyle(color: Colors.white),
              onChanged: (String? newValue) {
                controller.setFilterStatus(newValue!);
              },
              items: <String>['all', 'paid', 'pending']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value == 'all'
                        ? 'Semua Status'
                        : value == 'paid'
                            ? 'Dibayar'
                            : 'Tertunda',
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            width: 8.w,
          )
          // IconButton(
          //   onPressed: () async {
          //     final picked = await showDateRangePicker(
          //       context: context,
          //       firstDate: DateTime(2020),
          //       lastDate: DateTime.now().add(const Duration(days: 365)),
          //       initialDateRange: DateTimeRange(
          //         start: DateTime.now().subtract(const Duration(days: 30)),
          //         end: DateTime.now(),
          //       ),
          //     );
          //     if (picked != null) {
          //       final from = DateFormat('yyyy-MM-dd').format(picked.start);
          //       final to = DateFormat('yyyy-MM-dd').format(picked.end);
          //       await controller.loadSalaryHistory(fromDate: from, toDate: to);
          //     }
          //   },
          //   icon: Icon(
          //     Icons.calendar_month,
          //     size: 28.sp,
          //     color: Colors.white,
          //   ),
          // )
        ],
        backgroundColor: ConstColor.primaryColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.salaryList.isEmpty) {
          return const Center(child: Text("Data gaji tidak tersedia."));
        }

        return ListView.builder(
          itemCount: controller.salaryList
              .where((item) =>
                  controller.filterStatus.value == 'all' ||
                  item['status'] == controller.filterStatus.value)
              .length,
          itemBuilder: (context, index) {
            final filteredList = controller.salaryList
                .where((item) =>
                    controller.filterStatus.value == 'all' ||
                    item['status'] == controller.filterStatus.value)
                .toList();

            final item = filteredList[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              elevation: 2,
              child: ListTile(
                title: Text(
                  "Total Gaji: ${currencyFormat.format(double.tryParse(item['total_salary'] ?? '0'))}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                        "Potongan: ${currencyFormat.format(double.tryParse(item['total_deduction'] ?? '0'))}"),

                    Text("Tanggal Bayar: ${formatDate(item['pay_date'])}"),
                    // Text("Catatan: ${item['note']}"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await controller
                                .fetchDeductionsBySalaryId(item['id']);

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                              ),
                              builder: (_) {
                                return Obx(() {
                                  final deductions =
                                      controller.salaryDeductions;

                                  if (deductions.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text("Tidak ada data potongan."),
                                    );
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: deductions.length,
                                      itemBuilder: (_, index) {
                                        final d = deductions[index];
                                        return ListTile(
                                          title: Text(d['deduction_type']
                                              .toString()
                                              .capitalizeFirst!),
                                          subtitle: Text(d['note']),
                                          trailing: Text(
                                            currencyFormat.format(
                                                double.tryParse(
                                                    d['deduction_amount'] ??
                                                        '0')),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                });
                              },
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 6.sp),
                            padding: EdgeInsets.symmetric(
                                vertical: 8.sp, horizontal: 16.sp),
                            decoration: BoxDecoration(
                              color: ConstColor.primaryColor,
                              borderRadius: BorderRadius.circular(12.sp),
                            ),
                            child: Text(
                              'Detail Potongan',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: 'SemiBold',
                                color: ConstColor.white,
                              ),
                            ),
                          ),
                        ),
                        Chip(
                          label: Text(
                            item['status'] == 'paid' ? 'Dibayar' : 'Tertunda',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: item['status'] == 'paid'
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                          backgroundColor: item['status'] == 'paid'
                              ? Colors.green.withOpacity(0.2)
                              : Colors.orange.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: item['status'] == 'paid'
                                  ? Colors.green
                                  : Colors.orange,
                              width: 1,
                            ),
                          ),
                        ),
                      ],
                    )
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
