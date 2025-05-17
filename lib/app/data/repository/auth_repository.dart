import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/string.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login(String email, String password) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken == null) {
      return {
        "success": false,
        "message": "FCM token tidak ditemukan",
      };
    }

    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "fcm_token": fcmToken,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);

      final user = data['user'];
      await prefs.setInt('user_id', user['id']);
      await prefs.setString('name', user['name']);
      await prefs.setString('email', user['email']);
      await prefs.setString('address', user['address']);
      await prefs.setString('phone', user['phone']);
      await prefs.setString('role', user['role']);
      await prefs.setString('created_at', user['created_at']);
      await prefs.setString('updated_at', user['updated_at']);
      if (user['image'] != null) {
        await prefs.setString('image', user['image']);
      }
      await prefs.setString('fcm_token', fcmToken);

      return {
        "success": true,
        "message": data['message'],
        "user": user,
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
