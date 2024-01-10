import 'package:flutter/material.dart';

class ReviewModel extends ChangeNotifier {
  String product_id;
  String user_name, userImg;
  int rating;
  String review;
  ReviewModel({
    required this.product_id,
    required this.user_name,
    required this.userImg,
    required this.rating,
    required this.review,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      product_id: json['productId'].toString(),
      user_name: json['user_name'],
      userImg: json['user_img'],
      rating: json['rating'],
      review: json['review'],
    );
  }
}
