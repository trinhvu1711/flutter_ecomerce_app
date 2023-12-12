import 'dart:convert';

import 'package:flutter_ecomerce_app/models/user_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

// call api example
  Future<http.Response> fetchData(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Register
  Future<http.Response> registerUser(Map<String, dynamic> data) async {
    return await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
  }

  // Login
  Future<http.Response> loginUser(Map<String, dynamic> data) async {
    return await http.post(
      Uri.parse('$baseUrl/auth/authenticate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
  }

  // get user info
  Future<User?> getUserInfo(String bearerToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/info'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // get user info
  Future<void> logOutUser(String bearerToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );

      if (response.statusCode == 200) {
        print("logout success");
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // get user info
  Future<User> getUserInfoTest(String bearerToken) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/v1/users/info'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );

      // Kiểm tra xem yêu cầu có thành công không
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        // Xử lý lỗi ở đây
        print('Error: ${response.statusCode}');
        return Future.error('Failed to load user info');
      }
    } catch (e) {
      // Xử lý lỗi khác ở đây
      print('Error: $e');
      return Future.error('Failed to load user info');
    }
  }
}
