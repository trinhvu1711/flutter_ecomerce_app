import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/user_model.dart';
import 'package:flutter_ecomerce_app/models/wishlist_model.dart';
import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:flutter_ecomerce_app/services/auth_service.dart';
import 'package:flutter_ecomerce_app/services/my_app_function.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class WishListProvider with ChangeNotifier {
  final Map<String, WishListModel> _wishListItems = {};
  Map<String, WishListModel> get getWishLists {
    return _wishListItems;
  }

  Future<void> fetchWishlist() async {
    final apiService = ApiService();
    final authService = AuthService();
    bool isLoggedIn = await authService.isLoggedInAndRefresh(apiService);
    final token = await authService.getToken();
    if (token == null) return;
    final User? user = await apiService.getUserInfo(token);

    if (user == null || !isLoggedIn) {
      _wishListItems.clear();
      return;
    }
    try {
      final data = await apiService.getWishlist(token);
      if (data == null) {
        return;
      }
      final leng = data.length;
      for (int index = 0; index < leng; index++) {
        if (!data[index].removed) {
          _wishListItems.putIfAbsent(data[index].productId, () => data[index]);
        }
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  // add to wishlist database
  Future<void> addToWishlistDB({
    required String productId,
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
    final wishlistId = Random().nextInt(100000);
    final data = {"id": wishlistId, "product_id": productId, "removed": false};
    try {
      await apiService.addWishlist(token, data);
      await fetchWishlist();
      Fluttertoast.showToast(msg: "Item has been added");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeWishlistItemFromDB(
      {required String wishlistId,
      required String productId,
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
      "id": wishlistId,
      "product_id": productId,
      "removed": true,
    };
    try {
      // call api
      apiService.removeItemWishlist(token, data);
      await fetchWishlist();
      _wishListItems.remove(productId);
      Fluttertoast.showToast(msg: "Item has been removed");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearWishlistDB({required BuildContext context}) async {
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
      apiService.clearWishlist(token);
      await fetchWishlist();
      _wishListItems.clear();
      Fluttertoast.showToast(msg: "Wishlist has been cleared");
    } catch (e) {
      rethrow;
    }
  }

  void addOrRemoveOnWishList({required String productId}) {
    if (_wishListItems.containsKey(productId)) {
      _wishListItems.remove(productId);
    } else {
      _wishListItems.putIfAbsent(
        productId,
        () => WishListModel(
          productId: productId,
          wishListId: const Uuid().v4(),
          removed: false,
        ),
      );
    }

    notifyListeners();
  }

  bool isProductInWishList({required String productId}) {
    return _wishListItems.containsKey(productId);
  }

  void removeOneItem({required String productId}) {
    _wishListItems.remove(productId);
    notifyListeners();
  }

  void clearLocalWishList() {
    _wishListItems.clear();
    notifyListeners();
  }
}
