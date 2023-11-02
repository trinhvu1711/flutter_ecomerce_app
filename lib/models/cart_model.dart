import 'package:flutter/material.dart';

class CartModel with ChangeNotifier {
  final String productId;
  final String CartId;
  final int quantity;

  CartModel(
    this.productId,
    this.CartId,
    this.quantity,
  );
}
