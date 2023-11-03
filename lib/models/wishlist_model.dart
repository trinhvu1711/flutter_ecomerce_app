import 'package:flutter/material.dart';

class WishListModel with ChangeNotifier {
  final String productId;
  final String wishListId;

  WishListModel({
    required this.productId,
    required this.wishListId,
  });
}
