import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/services/assets_manager.dart';
import 'package:flutter_ecomerce_app/widgets/empty_bag.dart';
import 'package:flutter_ecomerce_app/widgets/products/product_widget.dart';

class WishlistScreen extends StatelessWidget {
  static const routName = "/WishlistScreen";
  const WishlistScreen({Key? key}) : super(key: key);
  final bool isEmpty = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetsManager.shoppingCart,
          ),
        ),
        title: const Text("Wishlist"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_forever_outlined),
          ),
        ],
      ),
      body: isEmpty
          ? EmptyBagWidget(
              imagePath: AssetsManager.bagWish,
              title: "No thing in ur wishlist",
              subTitle:
                  "Looks Like your cart is empty add \n something and make me happy",
              buttonText: "Shop now")
          : DynamicHeightGridView(
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              builder: (context, index) {
                return const ProductWidget(
                  productId: "",
                );
              },
              itemCount: 200,
              crossAxisCount: 2),
    );
  }
}
