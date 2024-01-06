import 'package:flutter/foundation.dart';
import 'package:flutter_ecomerce_app/models/review_model.dart';

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
}
