import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/string.dart';

class OrderRepository {
  Future<Map<String, dynamic>> getOrders() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        return {"success": false, "message": "Token tidak ditemukan"};
      }

      final response = await http.get(
        Uri.parse("$baseUrl/orders"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          return data;
        } else {
          return {"success": false, "message": data["message"]};
        }
      } else {
        return {
          "success": false,
          "message": "Mohon Selesaikan Kerjaan anda dulu"
        };
      }
    } catch (e) {
      return {"success": false, "message": "Terjadi kesalahan: $e"};
    }
  }

  Future<Map<String, dynamic>> takeOrder(int orderId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        return {"success": false, "message": "Token tidak ditemukan"};
      }

      final response = await http.post(
        Uri.parse("$baseUrl/orders/$orderId/take"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {"success": false, "message": "Terjadi kesalahan: $e"};
    }
  }

  Future<Map<String, dynamic>> getOrdersGoing() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        return {"success": false, "message": "Token tidak ditemukan"};
      }

      final response = await http.get(
        Uri.parse("$baseUrl/orders/ongoing"),
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
              "Gagal mengambil data orders. Server response: ${response.body}"
        };
      }
    } catch (e) {
      return {"success": false, "message": "Terjadi kesalahan: $e"};
    }
  }

  Future<Map<String, dynamic>> getCompletedOrderCount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        return {"success": false, "message": "Token tidak ditemukan"};
      }

      final response = await http.get(
        Uri.parse("$baseUrl/orders/completed/count"),
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
              "Gagal mengambil jumlah pesanan selesai. Server response: ${response.body}"
        };
      }
    } catch (e) {
      return {"success": false, "message": "Terjadi kesalahan: $e"};
    }
  }

  Future<Map<String, dynamic>> getCompletedOrders() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        return {"success": false, "message": "Token tidak ditemukan"};
      }

      final response = await http.get(
        Uri.parse("$baseUrl/orders/completed"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        print('object');
        print(response.body);
        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "message":
              "Gagal mengambil pesanan selesai. Server response: ${response.body}"
        };
      }
    } catch (e) {
      return {"success": false, "message": "Terjadi kesalahan: $e"};
    }
  }
}
