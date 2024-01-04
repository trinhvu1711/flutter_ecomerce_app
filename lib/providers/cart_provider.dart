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

  Future<void> fetchCart() async {
    final apiService = ApiService();
    final authService = AuthService();
    bool isLoggedIn = await authService.isLoggedInAndRefresh(apiService);
    final token = await authService.getToken();
    if (token == null) return;
    final User? user = await apiService.getUserInfo(token);

    if (user == null || !isLoggedIn) {
      _cartItems.clear();
      return;
    }
    try {
      final data = await apiService.getCart(token);
      if (data == null) {
        return;
      }
      final leng = data.length;
      for (int index = 0; index < leng; index++) {
        if (!data[index].removed) {
          _cartItems.putIfAbsent(data[index].productId, () => data[index]);
        }
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
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
      "removed": false
    };
    try {
      await apiService.addCart(token, data);
      await fetchCart();
    } catch (e) {
      rethrow;
    }
  }

  // add to cart local
  void addProductToCart({required String productId}) {
    _cartItems.putIfAbsent(
      productId,
      () => CartModel(
          productId: productId,
          cartId: const Uuid().v4(),
          quantity: 1,
          removed: false),
    );
    notifyListeners();
  }

  Future<void> removeCartItemFromDB(
      {required String cartId,
      required String productId,
      required int qty,
      required BuildContext context}) async {
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
    final data = {
      "id": cartId,
      "product_id": productId,
      "quantity": qty,
      "is_removed": true,
    };
    try {
      // call api
      apiService.removeItemCart(token, data);
      await fetchCart();
      _cartItems.remove(productId);
      Fluttertoast.showToast(msg: "Item has been removed");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearCartDB({required BuildContext context}) async {
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
    try {
      // call api
      apiService.clearCart(token);
      await fetchCart();
      _cartItems.clear();
    } catch (e) {
      rethrow;
    }
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
        removed: false,
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

  List<CartModel> getProductInCart() {
    List<CartModel> cartItems = [];
    _cartItems.forEach((key, value) {
      cartItems.insert(0, value);
    });
    return cartItems;
  }
}
