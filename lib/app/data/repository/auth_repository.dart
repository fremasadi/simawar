import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/string.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        "success": true,
        "message": data['message'],
        "user": data['user'],
        "token": data['token'],
      };
    } else {
      return {
        "success": false,
        "message": jsonDecode(response.body)['message'] ?? "Login gagal"
      };
    }
  }

  Future<Map<String, dynamic>> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      return {"success": false, "message": "Token tidak ditemukan"};
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Hapus token dan data user dari SharedPreferences
        await prefs.remove('token');
        await prefs.remove('user');
        return {"success": true, "message": "Logout berhasil"};
      } else {
        return {
          "success": false,
          "message": jsonDecode(response.body)['message'] ?? "Logout gagal"
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: ${e.toString()}"};
    }
  }
}
