import 'package:flutter_ecomerce_app/models/categories_model.dart';
import 'package:flutter_ecomerce_app/services/assets_manager.dart';

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
}
