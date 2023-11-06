import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/viewed_products.dart';
import 'package:uuid/uuid.dart';

class ViewedProdvider with ChangeNotifier {
  final Map<String, ViewedProdModel> _viewedProdItems = {};
  Map<String, ViewedProdModel> get getViewedProds {
    return _viewedProdItems;
  }

  void addViewedProd({required String productId}) {
    if (_viewedProdItems.containsKey(productId)) {
      _viewedProdItems.remove(productId);
    } else {
      _viewedProdItems.putIfAbsent(
        productId,
        () => ViewedProdModel(
          productId: productId,
          viewedProdId: const Uuid().v4(),
        ),
      );
    }

    notifyListeners();
  }
}
