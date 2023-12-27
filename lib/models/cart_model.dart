import 'package:flutter/material.dart';

class CartModel with ChangeNotifier {
  final String productId;
  final String cartId;
  final int quantity;

  CartModel({
    required this.productId,
    required this.cartId,
    required this.quantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      productId: json['product_id'].toString(),
      cartId: json['id'].toString(),
      quantity: json['quantity'] as int,
    );
  }
}
