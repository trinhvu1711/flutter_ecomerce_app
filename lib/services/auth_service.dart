import 'dart:convert';

import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _apiService = ApiService();
  late SharedPreferences _prefs;
  AuthService() {
    _initPrefs();
  }
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save token when login is successful
  Future<void> saveToken(String token) async {
    await _initPrefs();
    _prefs.setString('token', token);
  }

  // Get token when the app starts
  Future<String?> getToken() async {
    await _initPrefs();
    return _prefs.getString('token');
  }

  // Check if the user is logged in
  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null;
  }

  // Register a new user and return the token
  Future<String> registerUser(Map<String, dynamic> userData) async {
    final response = await _apiService.registerUser(userData);
    if (response.statusCode == 200) {
      try {
        final token = json.decode(response.body)['access_token'];
        return token;
      } catch (e) {
        throw Exception('Failed to parse token');
      }
    } else {
      throw Exception('Failed to register user');
    }
  }

  // Register a new user and return the token
  Future<String> loginUser(Map<String, dynamic> userData) async {
    final response = await _apiService.loginUser(userData);
    if (response.statusCode == 200) {
      try {
        final token = json.decode(response.body)['access_token'];
        return token;
      } catch (e) {
        throw Exception('Failed to parse token');
      }
    } else {
      throw Exception('Failed to login user');
    }
  }
}
