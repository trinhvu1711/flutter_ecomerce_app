import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/order_model.dart';
import 'package:flutter_ecomerce_app/providers/cart_provider.dart';
import 'package:flutter_ecomerce_app/providers/location_provider.dart';
import 'package:flutter_ecomerce_app/providers/paymentMethod_provider.dart';
import 'package:flutter_ecomerce_app/providers/shipping_provider.dart';
import 'package:uuid/uuid.dart';

class OrderProvider with ChangeNotifier {
  final Map<String, OrderModel> _orders = {};
  Map<String, OrderModel> get orders => _orders;

  void addOrder(
      {required CartProvider cart,
      required LocationProvider location,
      required PaymentMethodProvider payment,
      required StatusShippingProvider status,
      required double productCost,
      required double totalCost}) {
    String id = const Uuid().v4();
    _orders.putIfAbsent(
        id,
        () => OrderModel(
            orderId: id,
            cartItem: cart.getProductInCart(),
            location: location.consumeLocation!,
            paymentMethodId: payment.chooseMethod,
            statusShipping: status.statusOrder,
            productCost: productCost,
            shippingFee: 100,
            totalCost: totalCost));
    notifyListeners();
  }

  String validateOrder(
      {required CartProvider cart,
      required LocationProvider location,
      required PaymentMethodProvider payment,
      required StatusShippingProvider status}) {
    var cartItems = cart.getProductInCart();
    var locationData = location.consumeLocation;
    var paymentMethod = payment.chooseMethod;
    var shippingStatus = status.statusOrder;

    if (cartItems.isEmpty) {
      return 'Cart items are empty';
    } else if (locationData == null) {
      return 'Location data is null';
    } else if (paymentMethod.isEmpty) {
      return 'Payment method is empty';
    } else if (shippingStatus.isEmpty) {
      return 'Shipping status is empty';
    } else {
      return 'All values are valid';
    }
  }
}
