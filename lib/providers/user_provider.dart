import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/user_model.dart';
import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:flutter_ecomerce_app/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  User? userModel;

  User? get getUserModel => userModel;
  Future<User?> fetchUserInfo() async {
    try {
      final service = ApiService();
      final authService = AuthService();
      String? token = await authService.getToken(service);

      if (token != null) {
        User? user = await service.getUserInfo(token);
        return user;
      } else {
        // Token is null, handle accordingly (throw an error, return null, etc.)
        return null;
      }
    } catch (e) {
      // Xử lý lỗi ở đây
      print('Error fetching user info: $e');
      return null;
    }
  }

  void logout() {
    // Gán userModel thành null khi logout
    userModel = null;
  }
}
