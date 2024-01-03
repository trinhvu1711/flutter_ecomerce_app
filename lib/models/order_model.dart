import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/cart_model.dart';
import 'package:flutter_ecomerce_app/models/location_model.dart';

class OrderModel extends ChangeNotifier {
  final String orderId;
  final List<CartModel> cartItem;
  final LocationModel? location;
  final String paymentMethodId;
  final String statusShipping;
  final double productCost;
  final double shippingFee;
  final double totalCost;
  final bool removed;
  OrderModel({
    required this.orderId,
    required this.cartItem,
    required this.location,
    required this.paymentMethodId,
    required this.statusShipping,
    required this.productCost,
    required this.shippingFee,
    required this.totalCost,
    required this.removed,
  });
  int getQtyItems() {
    int total = 0;
    cartItem.forEach((element) {
      total += element.quantity;
    });
    return total;
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['id'].toString(),
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      paymentMethodId: json['payment_id'].toString(),
      statusShipping: json['status_shipping_id'].toString(),
      productCost: json['productCost'].toDouble(),
      shippingFee: json['shipping_fee'].toDouble(),
      totalCost: json['total_cost'].toDouble(),
      cartItem: List<CartModel>.from(
        json['carts'].map((cart) => CartModel.fromJson(cart)),
      ),
      removed: json['removed'] as bool ?? true,
    );
  }
}
