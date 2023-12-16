import 'package:flutter_ecomerce_app/models/categories_model.dart';
import 'package:flutter_ecomerce_app/services/assets_manager.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static const String imageUrl =
      'https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png';
  static List<String> bannerImage = [
    AssetsManager.banner1,
    AssetsManager.banner2
  ];
  static List<CategoriesModel> categoriesList = [
    CategoriesModel(
      id: AssetsManager.mobiles,
      name: "Phones",
      image: AssetsManager.mobiles,
    ),
    CategoriesModel(
      id: AssetsManager.mobiles,
      name: "Electronics",
      image: AssetsManager.electronics,
    ),
    CategoriesModel(
      id: AssetsManager.mobiles,
      name: "Cosmetics",
      image: AssetsManager.cosmetics,
    ),
    CategoriesModel(
      id: AssetsManager.mobiles,
      name: "Laptop",
      image: AssetsManager.pc,
    ),
    CategoriesModel(
      id: AssetsManager.mobiles,
      name: "Clothes",
      image: AssetsManager.fashion,
    ),
    CategoriesModel(
      id: AssetsManager.mobiles,
      name: "Shoes",
      image: AssetsManager.shoes,
    ),
    CategoriesModel(
      id: AssetsManager.mobiles,
      name: "Books",
      image: AssetsManager.book,
    ),
  ];
  static String apiKey = const String.fromEnvironment('CLOUDINARY_API_KEY',
      defaultValue: '777294396529528');
  static String apiSecret = const String.fromEnvironment(
      'CLOUDINARY_API_SECRET',
      defaultValue: 'wMTNjgGhLWZ6LCJv8hi6DG1zCZk');
  static String cloudName = const String.fromEnvironment(
      'CLOUDINARY_CLOUD_NAME',
      defaultValue: 'dqewxfmml');
  static String folder =
      const String.fromEnvironment('CLOUDINARY_FOLDER', defaultValue: '');
  static String uploadPreset = const String.fromEnvironment(
      'CLOUDINARY_UPLOAD_PRESET',
      defaultValue: 'vuuzgtdo');

  static List<String> categoriesListDropDown = [
    'Phones',
    'Laptops',
    'Electronics',
    'Watches',
    'Clothes',
    'Shoes',
    'Books',
    'Cosmetics',
    'Accessories'
  ];

  static List<DropdownMenuItem<String>>? get categoriesDropDownList {
    List<DropdownMenuItem<String>>? menuItem =
        List<DropdownMenuItem<String>>.generate(
      categoriesListDropDown.length,
      (index) => DropdownMenuItem(
        value: categoriesListDropDown[index],
        child: Text(categoriesListDropDown[index]),
      ),
    );
    return menuItem;
  }
}
