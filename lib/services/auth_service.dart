import 'dart:convert';

import 'package:flutter_ecomerce_app/providers/user_provider.dart';
import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
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
  Future<String> registerUser(
      Map<String, dynamic> userData, ApiService apiService) async {
    final response = await apiService.registerUser(userData);
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
  Future<String> loginUser(
      Map<String, dynamic> userData, ApiService apiService) async {
    final response = await apiService.loginUser(userData);
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

  Future<void> logoutUser(ApiService apiService) async {
    try {
      await _initPrefs();
      await _prefs.remove('token');
      UserProvider userProvider = UserProvider();
      userProvider.logout();
      String? token = await getToken();
      apiService.logOutUser(token!);
    } catch (e) {
      // Xử lý lỗi ở đây
      print('Error during logout: $e');
    }
  }
}
