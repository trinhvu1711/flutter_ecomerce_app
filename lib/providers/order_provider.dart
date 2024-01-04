import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/order_model.dart';
import 'package:flutter_ecomerce_app/models/user_model.dart';
import 'package:flutter_ecomerce_app/providers/cart_provider.dart';
import 'package:flutter_ecomerce_app/providers/location_provider.dart';
import 'package:flutter_ecomerce_app/providers/paymentMethod_provider.dart';
import 'package:flutter_ecomerce_app/providers/shipping_provider.dart';
import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:flutter_ecomerce_app/services/auth_service.dart';
import 'package:flutter_ecomerce_app/services/my_app_function.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class OrderProvider with ChangeNotifier {
  final Map<String, OrderModel> _orders = {};
  Map<String, OrderModel> get orders => _orders;

  Future<void> fetchOrder() async {
    final apiService = ApiService();
    final authService = AuthService();
    bool isLoggedIn = await authService.isLoggedInAndRefresh(apiService);
    final token = await authService.getToken();
    if (token == null) return;
    final User? user = await apiService.getUserInfo(token);

    if (user == null || !isLoggedIn) {
      _orders.clear();
      return;
    }
    try {
      final data = await apiService.getOrder(token);
      if (data == null) {
        return;
      }
      final leng = data.length;
      for (int index = 0; index < leng; index++) {
        if (!data[index].removed) {
          _orders.putIfAbsent(data[index].orderId, () => data[index]);
        }
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  // add order db
  Future<void> addToOrderDB({
    required OrderModel orderModel,
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
    final orderData = {
      "id": orderModel.orderId,
      "location": orderModel.location,
      "payment_id": orderModel.paymentMethodId,
      "status_shipping_id": orderModel.statusShipping,
      "shipping_fee": orderModel.shippingFee,
      "total_cost": orderModel.totalCost,
      "productCost": orderModel.productCost,
      "removed": false,
      "carts": orderModel.cartItem
          .map((cartItem) => {
                "id": cartItem.cartId,
                "product_id": cartItem.productId,
                "quantity": cartItem.quantity,
                "removed": true,
              })
          .toList(),
    };

    try {
      await apiService.addOrder(token, orderData);
      await fetchOrder();
      Fluttertoast.showToast(msg: "Order success");
    } catch (e) {
      rethrow;
    }
  }

  // add order local
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
            location: location.locationItems!,
            paymentMethodId: payment.chooseMethod,
            statusShipping: status.statusOrder,
            productCost: productCost,
            shippingFee: 100,
            totalCost: totalCost,
            removed: false));
    notifyListeners();
  }

  String validateOrder(
      {required CartProvider cart,
      required LocationProvider location,
      required PaymentMethodProvider payment,
      required StatusShippingProvider status}) {
    var cartItems = cart.getProductInCart();
    var locationData = location.locationItems;
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

  void clearOrderData() {
    _orders.clear;
    notifyListeners();
  }
}
