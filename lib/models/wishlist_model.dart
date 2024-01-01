import 'package:flutter/material.dart';

class WishListModel with ChangeNotifier {
  final String productId;
  final String wishListId;
  final bool removed;
  WishListModel({
    required this.productId,
    required this.wishListId,
    required this.removed,
  });
  factory WishListModel.fromJson(Map<String, dynamic> json) {
    return WishListModel(
      productId: json['product_id'].toString(),
      wishListId: json['id'].toString(),
      removed: json['removed'] as bool ?? true,
    );
  }
}
