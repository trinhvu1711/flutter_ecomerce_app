import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/const/app_constants.dart';

class User with ChangeNotifier {
  final String userId, userName, userLastName, userImage, userEmail, role;
  final List userCart, userWish;
  User({
    required this.userId,
    required this.userName,
    required this.userLastName,
    required this.userImage,
    required this.userEmail,
    required this.userCart,
    required this.userWish,
    required this.role,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: '',
      role: json['role'],
      userName: json['first_name'],
      userEmail: json['email'],
      userImage: json['img_url'] ?? AppConstants.imageUrl,
      userCart: [],
      userWish: [],
      userLastName: json['last_name'],
    );
  }
}
