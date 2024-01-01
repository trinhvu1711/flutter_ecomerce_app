import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/cart_model.dart';
import 'package:flutter_ecomerce_app/models/location_model.dart';

class OrderModel extends ChangeNotifier {
  final String orderId;
  final List<CartModel> cartItem;
  final LocationModel location;
  final String paymentMethodId;
  final String statusShipping;
  final double productCost;
  final double shippingFee;
  final double totalCost;

  OrderModel(
      {required this.orderId,
      required this.cartItem,
      required this.location,
      required this.paymentMethodId,
      required this.statusShipping,
      required this.productCost,
      required this.shippingFee,
      required this.totalCost});
  int getQtyItems() {
    int total = 0;
    cartItem.forEach((element) {
      total += element.quantity;
    });
    return total;
  }
}
