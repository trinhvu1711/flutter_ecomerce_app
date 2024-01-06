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
}
