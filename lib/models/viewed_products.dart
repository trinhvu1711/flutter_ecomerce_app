import 'package:flutter/material.dart';

class ViewedProdModel with ChangeNotifier {
  final String productId;
  final String viewedProdId;

  ViewedProdModel({
    required this.productId,
    required this.viewedProdId,
  });
}
