import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/string.dart';

class AttendanceRepository {
  Future<Map<String, dynamic>> getAttendanceHistory({
    String? startDate,
    String? endDate,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      return {"success": false, "message": "Token tidak ditemukan"};
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/attendance/history').replace(queryParameters: {
          if (startDate != null) 'start_date': startDate,
          if (endDate != null) 'end_date': endDate,
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Parse respons ke JSON
      final responseData = jsonDecode(response.body);

      // Jika status 200, tambahkan flag success:true
      if (response.statusCode == 200) {
        responseData['success'] = true;
        return responseData;
      } else {
        // Jika ada error dari API
        return {
          "success": false,
          "message":
              responseData['message'] ?? "Gagal mengambil riwayat absensi"
        };
      }
    } catch (e) {
      // Jika terjadi error dalam proses HTTP
      return {"success": false, "message": "Error: ${e.toString()}"};
    }
  }

  Future<Map<String, dynamic>> checkInAttendance(String qrCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      return {"success": false, "message": "Token tidak ditemukan"};
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/attendance/check-in'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"qr_code": qrCode}),
      );

      // Parse respons ke JSON
      final responseData = jsonDecode(response.body);

      // Jika status 200, tambahkan flag success:true
      if (response.statusCode == 200) {
        // Tambahkan field success ke respons API
        responseData['success'] = true;
        return responseData;
      } else {
        // Jika ada error dari API
        return {
          "success": false,
          "message": responseData['message'] ?? "Gagal melakukan check-in"
        };
      }
    } catch (e) {
      // Jika terjadi error dalam proses HTTP
      return {"success": false, "message": "Error: ${e.toString()}"};
    }
  }
}
