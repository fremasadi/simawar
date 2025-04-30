import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/string.dart';

class UserRepository {
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        return {"success": false, "message": "Token tidak ditemukan"};
      }

      final response = await http.get(
        Uri.parse("$baseUrl/user/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "message":
              "Gagal mengambil data user. Server response: ${response.body}"
        };
      }
    } catch (e) {
      return {"success": false, "message": "Terjadi kesalahan: $e"};
    }
  }
}
