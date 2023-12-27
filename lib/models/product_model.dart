import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProductModel with ChangeNotifier {
  final String productId,
      productTitle,
      productCategory,
      productDescription,
      productImage;
  final double productPrice;
  final int productQuantity;
  final DateTime? createDate;
  final DateTime? lastModified;
  int? createdBy;
  int? lastModifiedBy;

  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productQuantity,
    this.createDate,
    this.lastModified,
    this.createdBy,
    this.lastModifiedBy,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['id'].toString() ?? '',
      productTitle: json['name'] ?? '',
      productPrice: (json['price'] as num?)?.toDouble() ?? 0.0,
      productCategory: json['category'] ?? '',
      productDescription: json['description'] ?? '',
      productImage: json['img'] ?? '',
      productQuantity: (json['quantity'] as int?) ?? 0,
      createDate: json['createDate'] != null
          ? DateTime.parse(json['createDate'])
          : null,
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'])
          : null,
      createdBy: json['createdBy'] as int?,
      lastModifiedBy: json['lastModifiedBy'] as int?,
    );
  }
}
