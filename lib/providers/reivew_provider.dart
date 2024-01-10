import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/review_model.dart';
import 'package:flutter_ecomerce_app/models/user_model.dart';
import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:flutter_ecomerce_app/services/auth_service.dart';
import 'package:flutter_ecomerce_app/services/my_app_function.dart';

class ReviewProvider with ChangeNotifier {
  final List<ReviewModel> _reviews = [
    ReviewModel(
        product_id: '1',
        rating: 4,
        review: 'acacas',
        userImg:
            'https://images.pexels.com/photos/16794803/pexels-photo-16794803/free-photo-of-da-b-n-tau-m-t-ti-n-di-bi-n.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
        user_name: 'acvc'),
    ReviewModel(
        product_id: '1',
        rating: 2,
        review: 'acacas',
        userImg:
            'https://images.pexels.com/photos/16794803/pexels-photo-16794803/free-photo-of-da-b-n-tau-m-t-ti-n-di-bi-n.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
        user_name: 'acvc'),
    ReviewModel(
        product_id: '1',
        rating: 1,
        review: 'acacas',
        userImg:
            'https://images.pexels.com/photos/16794803/pexels-photo-16794803/free-photo-of-da-b-n-tau-m-t-ti-n-di-bi-n.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
        user_name: 'acvc'),
    ReviewModel(
        product_id: '1',
        rating: 4,
        review: 'acacas',
        userImg:
            'https://images.pexels.com/photos/16794803/pexels-photo-16794803/free-photo-of-da-b-n-tau-m-t-ti-n-di-bi-n.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
        user_name: 'acvc'),
    ReviewModel(
        product_id: '1',
        rating: 5,
        review: 'acacas',
        userImg:
            'https://images.pexels.com/photos/16794803/pexels-photo-16794803/free-photo-of-da-b-n-tau-m-t-ti-n-di-bi-n.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
        user_name: 'acvc')
  ];
  List<ReviewModel> get reviews => _reviews;
  void addReview(
      {required String username,
      required String userimg,
      required String productid,
      required int rating,
      required String reviews}) {
    ReviewModel review = ReviewModel(
        product_id: productid,
        user_name: username,
        userImg: userimg,
        rating: rating,
        review: reviews);
    _reviews.add(review);
    notifyListeners();
  }

  List<ReviewModel>? getListProductReviews({required String productId}) {
    var selectedReviews =
        _reviews.where((review) => review.product_id == productId).toList();
    if (selectedReviews.isEmpty) {
      return null;
    }
    return selectedReviews;
  }

  int totalReviews({required String productId}) {
    return _reviews.where((review) => review.product_id == productId).length;
  }

  double averageRating({required String productId}) {
    var selectedReviews =
        _reviews.where((review) => review.product_id == productId).toList();
    if (selectedReviews.isEmpty) {
      return 0;
    }
    var total = selectedReviews.fold(
        0, (previousValue, review) => previousValue + review.rating);
    return total / selectedReviews.length;
  }

  Future<void> fetchReview() async {
    final apiService = ApiService();
    final authService = AuthService();
    bool isLoggedIn = await authService.isLoggedInAndRefresh(apiService);
    final token = await authService.getToken();
    if (token == null) return;
    final User? user = await apiService.getUserInfo(token);

    if (user == null || !isLoggedIn) {
      _reviews.clear();
      return;
    }
    try {
      final data = await apiService.getReview();
      if (data == null) {
        return;
      }
      _reviews.clear();
      _reviews.addAll(data);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  // add to cart database
  Future<void> addToReviewDB({
    required String username,
    required String userimg,
    required String productid,
    required int rating,
    required String reviews,
    required BuildContext context,
  }) async {
    final apiService = ApiService();
    final authService = AuthService();
    bool isLoggedIn = await authService.isLoggedInAndRefresh(apiService);
    final token = await authService.getToken();
    final User? user = await apiService.getUserInfo(token!);
    if (user == null || !isLoggedIn) {
      MyAppFunction.showErrorOrWarningDialog(
        context: context,
        subtitle: "Please login first",
        fct: () {},
      );
      return;
    }
    final reviewId = Random().nextInt(100000);
    final data = {
      "id": reviewId,
      "product_id": productid,
      "user_name": username,
      "user_img": userimg,
      "rating": rating,
      "review": reviews,
      "removed": false,
    };
    try {
      await apiService.addReview(token, data);
      await fetchReview();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
