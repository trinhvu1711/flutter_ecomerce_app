import 'dart:convert';

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
}
