import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/wishlist_model.dart';
import 'package:uuid/uuid.dart';

class WishListProvider with ChangeNotifier {
  final Map<String, WishListModel> _wishListItems = {};
  Map<String, WishListModel> get getWishLists {
    return _wishListItems;
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
