import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/cart_model.dart';
import 'package:flutter_ecomerce_app/models/user_model.dart';
import 'package:flutter_ecomerce_app/providers/products_provider.dart';
import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:flutter_ecomerce_app/services/auth_service.dart';
import 'package:flutter_ecomerce_app/services/my_app_function.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};
  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }

  // add to cart database
  Future<void> addToCartDB({
    required String productId,
    required int qty,
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
    final cartId = Random().nextInt(100000);
    final data = {
      "id": cartId,
      "product_id": productId,
      "quantity": qty,
    };
    try {
      await apiService.addCart(token, data);
      Fluttertoast.showToast(msg: "Item has been added");
    } catch (e) {
      rethrow;
    }
  }

  // add to cart local
  void addProductToCart({required String productId}) {
    _cartItems.putIfAbsent(
      productId,
      () => CartModel(
          productId: productId, cartId: const Uuid().v4(), quantity: 1),
    );
    notifyListeners();
  }

  bool isProductInCart({required String productId}) {
    return _cartItems.containsKey(productId);
  }

  double getTotal({required ProductProvider productProvider}) {
    double total = 0;
    _cartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findByProdId(value.productId);
      if (getCurrProduct != null) {
        total += getCurrProduct.productPrice * value.quantity;
      }
    });
    return total;
  }

  int getQty() {
    int total = 0;
    _cartItems.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }

  void updateQty({required String productId, required int qty}) {
    _cartItems.update(
      productId,
      (cartItem) => CartModel(
        cartId: cartItem.cartId,
        productId: productId,
        quantity: qty,
      ),
    );
    notifyListeners();
  }

  void removeOneItem({required String productId}) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clearLocalCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
