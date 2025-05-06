import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/string.dart';

class SalaryRepository {
  Future<Map<String, dynamic>> fetchSalaryHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      return {"success": false, "message": "Token tidak ditemukan"};
    }

    final url = Uri.parse('$baseUrl/salary-history');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          return {
            "success": true,
            "data": jsonData['data'],
          };
        } else {
          return {
            "success": false,
            "message": jsonData['message'] ?? 'Gagal mengambil data',
          };
        }
      } else {
        return {
          "success": false,
          "message": 'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Terjadi kesalahan: $e",
      };
    }
  }

  Future<Map<String, dynamic>> getSalaryDeductions(int salaryId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      return {"success": false, "message": "Token tidak ditemukan"};
    }

    final response = await http.get(
      Uri.parse("$baseUrl/salary-deductions/$salaryId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {"success": true, "data": data['data']};
    } else {
      return {"success": false, "message": "Gagal mengambil potongan gaji"};
    }
  }
}
