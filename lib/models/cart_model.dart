import 'package:flutter/material.dart';

class CartModel with ChangeNotifier {
  final String productId;
  final String cartId;
  final int quantity;
  final bool removed;
  CartModel({
    required this.productId,
    required this.cartId,
    required this.quantity,
    required this.removed,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      productId: json['product_id'].toString(),
      cartId: json['id'].toString(),
      quantity: json['quantity'] as int,
      removed: json['removed'] as bool ?? true,
    );
  }
}
