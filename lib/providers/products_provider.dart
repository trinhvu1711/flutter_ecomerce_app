import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/const/app_constants.dart';
import 'package:flutter_ecomerce_app/models/product_model.dart';
import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:flutter_ecomerce_app/services/auth_service.dart';
import 'package:uuid/uuid.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> products = AppConstants.ListProducts;
  List<ProductModel> get getProducts {
    return products;
  }

  final apiService = ApiService();
  Future<List<ProductModel>?> fetchProducts() async {
    try {
      List<ProductModel>? productData = await apiService.getProductInfo();
      if (productData != null) {
        products.clear();
        products.addAll(productData);

        // Sort products by createDate in descending order (newest first)
        products.sort((a, b) {
          final aLastModified = a.lastModified;
          final bLastModified = b.lastModified;

          if (aLastModified != null && bLastModified != null) {
            return bLastModified.compareTo(aLastModified);
          } else if (aLastModified != null) {
            // b.lastModified is null, place a first
            return -1;
          } else if (bLastModified != null) {
            // a.lastModified is null, place b first
            return 1;
          } else {
            // Both lastModified are null, consider them equal
            return 0;
          }
        });
        notifyListeners();
        return products;
      } else {
        // Handle error if productData is null
      }
    } catch (e) {
      print('Error adding products from API: $e');
      // Handle error
    }
  }

  Stream<List<ProductModel>?> fetchProductsStream() async* {
    try {
      List<ProductModel>? productData = await apiService.getProductInfo();
      if (productData != null) {
        products.clear();
        products.addAll(productData);
        notifyListeners();
        yield products; // Use 'yield' to return a stream value
      } else {
        // Handle error if productData is null
        print('Error: productData is null');
      }
    } catch (e) {
      print('Error adding products from API: $e');
      // Handle error
    }
  }

  ProductModel? findByProdId(String productId) {
    if (products.where((element) => element.productId == productId).isEmpty) {
      return null;
    }
    return products.firstWhere((element) => element.productId == productId);
  }

  List<ProductModel> findByCategory({required String categoryName}) {
    List<ProductModel> categoryList = products
        .where((element) => element.productCategory
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return categoryList;
  }

  List<ProductModel> searchQuery({
    required String searchText,
    required List<ProductModel> passedList,
  }) {
    List<ProductModel> searchList = passedList
        .where((element) => element.productTitle
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();
    return searchList;
  }
}
