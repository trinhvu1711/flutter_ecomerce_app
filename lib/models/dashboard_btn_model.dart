import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/edit_upload_product.dart';
import 'package:flutter_ecomerce_app/screens/search_screen.dart';
import 'package:flutter_ecomerce_app/screens/search_screen_admin.dart';
import 'package:flutter_ecomerce_app/services/assets_manager.dart';

class DashboardButtonModel {
  final String text, imagePath;
  final Function onpressed;

  DashboardButtonModel({
    required this.text,
    required this.imagePath,
    required this.onpressed,
  });
  static List<DashboardButtonModel> dashboardBtnList(context) => [
        DashboardButtonModel(
          text: "Add new Product",
          imagePath: AssetsManager.cloud,
          onpressed: () {
            Navigator.pushNamed(context, EditUploadProductScreen.routeName);
          },
        ),
        DashboardButtonModel(
          text: "inspect all products",
          imagePath: AssetsManager.shoppingCart,
          onpressed: () {
            Navigator.pushNamed(context, SearchScreenAdmin.routName);
          },
        ),
        DashboardButtonModel(
          text: "View Orders",
          imagePath: AssetsManager.order,
          onpressed: () {},
        ),
      ];
}
