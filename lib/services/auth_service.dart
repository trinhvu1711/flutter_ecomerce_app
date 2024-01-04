import 'dart:convert';

import 'package:flutter_ecomerce_app/providers/cart_provider.dart';
import 'package:flutter_ecomerce_app/providers/location_provider.dart';
import 'package:flutter_ecomerce_app/providers/order_provider.dart';
import 'package:flutter_ecomerce_app/providers/user_provider.dart';
import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:flutter_ecomerce_app/services/my_app_function.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  late SharedPreferences _prefs;
  AuthService() {
    _initPrefs();
  }
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void clearPrefs() {
    _initPrefs();
    _prefs.remove('accessToken');
    _prefs.remove('refreshToken');
    _prefs.clear();
  }

  // Save token when login is successful
  Future<void> saveToken(String accessToken, String refreshToken) async {
    await _initPrefs();
    _prefs.setString('accessToken', accessToken);
    _prefs.setString('refreshToken', refreshToken);
  }

  // Get token when the app starts
  Future<String?> getToken() async {
    await _initPrefs();
    return _prefs.getString('accessToken');
  }

  // get refresh token
  Future<String?> getRefreshToken() async {
    await _initPrefs();
    return _prefs.getString('refreshToken');
  }

// Refresh token
  Future<String?> refreshToken(ApiService apiService) async {
    var refreshToken = _prefs.getString('refreshToken');
    if (refreshToken != null && !isTokenExpired(refreshToken)) {
      try {
        final response = await apiService.getAccessToken(refreshToken);
        String accessToken = json.decode(response.body)['access_token'];
        return accessToken;
      } catch (e) {
        print('Error refreshing token: $e');
        return null; // Handle the error as needed
      }
    }
    return null; // Token is expired or not available
  }

// Check if the user is logged in and refresh token if needed
  Future<bool> isLoggedInAndRefresh(ApiService apiService) async {
    String? accessToken = await getToken();
    String? refreshTokenValue = await getRefreshToken();

    if (accessToken == null) {
      return false;
    } else if (refreshTokenValue != null &&
        !isTokenExpired(refreshTokenValue)) {
      // Token is still valid
      return true;
    } else {
      // Refresh token or handle the case differently (e.g., navigate to login screen)
      String? newAccessToken = await refreshToken(apiService);
      if (newAccessToken != null) {
        saveToken(newAccessToken, refreshTokenValue!);
        return true;
      }
      return false; // Return true if refresh was successful
    }
  }

  bool isTokenExpired(String token) {
    try {
      // Check if the token is expired
      return JwtDecoder.isExpired(token);
    } catch (e) {
      print('Error decoding or checking JWT token: $e');
      return true; // Consider the token expired if there's an issue decoding it
    }
  }

  // Register a new user and return the token
  Future<Map<String, String>> registerUser(
      Map<String, dynamic> userData, ApiService apiService) async {
    final response = await apiService.registerUser(userData);
    if (response.statusCode == 200) {
      try {
        final Map<String, String> tokens = {
          'access_token': json.decode(response.body)['access_token'],
          'refresh_token': json.decode(response.body)['refresh_token'],
        };
        return tokens;
      } catch (e) {
        throw Exception('Failed to parse token');
      }
    } else {
      throw Exception('Failed to register user');
    }
  }

  // Register a new user and return the token
  Future<Map<String, String>> loginUser(
      Map<String, dynamic> userData, ApiService apiService) async {
    final response = await apiService.loginUser(userData);
    if (response.statusCode == 200) {
      try {
        final Map<String, String> tokens = {
          'access_token': json.decode(response.body)['access_token'],
          'refresh_token': json.decode(response.body)['refresh_token'],
        };
        return tokens;
      } catch (e) {
        throw Exception('Failed to parse token');
      }
    } else {
      throw Exception('Failed to login user');
    }
  }

  Future<void> logoutUser() async {
    try {
      final apiService = ApiService();
      final authService = AuthService();
      // Log out user from the API
      final token = await authService.getToken();
      apiService.logOutUser(token!);

      // Clear data from shared preferences
      await _prefs.remove('accessToken');
      await _prefs.remove('refreshToken');
      await _prefs.clear();

      // Clear user data
      UserProvider userProvider = UserProvider();
      userProvider.clearUserData();

      // Clear cart data
      CartProvider cartProvider = CartProvider();
      cartProvider.clearLocalCart();

      // Clear location data
      LocationProvider locationProvider = LocationProvider();
      locationProvider.clearLocationData();

      // Clear order data
      OrderProvider orderProvider = OrderProvider();
      orderProvider.clearOrderData();
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
