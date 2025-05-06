import 'package:get/get.dart';

import '../../../data/repository/salary_repository.dart';

class SalaryController extends GetxController {
  final SalaryRepository repository = SalaryRepository();
  var salaryList = [].obs;
  var isLoading = false.obs;
  var salaryDeductions = [].obs;

  Future<void> loadSalaryHistory() async {
    isLoading.value = true;

    final result = await repository.fetchSalaryHistory();

    if (result["success"]) {
      salaryList.value = result["data"];
    } else {
      Get.snackbar("Error", result["message"]);
    }

    isLoading.value = false;
  }

  Future<void> fetchDeductionsBySalaryId(int salaryId) async {
    final result = await repository.getSalaryDeductions(salaryId);
    if (result['success']) {
      salaryDeductions.value = result['data'];
    } else {
      Get.snackbar("Selamat", 'Anda Tidak Mempunyai Potongan');
    }
  }
}
