import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/providers/wishList_provider.dart';
import 'package:flutter_ecomerce_app/services/assets_manager.dart';
import 'package:flutter_ecomerce_app/services/my_app_function.dart';
import 'package:flutter_ecomerce_app/widgets/empty_bag.dart';
import 'package:flutter_ecomerce_app/widgets/products/product_widget.dart';
import 'package:flutter_ecomerce_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  static const routName = "/WishlistScreen";
  const WishlistScreen({Key? key}) : super(key: key);
  final bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishListProvider>(context);
    return wishListProvider.getWishLists.isEmpty
        ? EmptyBagWidget(
            imagePath: AssetsManager.bagWish,
            title: "No thing in ur wishlist",
            subTitle:
                "Looks Like your wishlist is empty add \n something and make me happy",
            buttonText: "Shop now",
          )
        : Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  AssetsManager.shoppingCart,
                ),
              ),
              title: TitleTextWidget(
                  label: "WishList (${wishListProvider.getWishLists.length})"),
              actions: [
                IconButton(
                  onPressed: () {
                    MyAppFunction.showErrorOrWarningDialog(
                        isError: false,
                        context: context,
                        fct: () {
                          wishListProvider.clearLocalWishList();
                          wishListProvider.clearWishlistDB(context: context);
                        },
                        subtitle: "Clear wishlist ?");
                  },
                  icon: const Icon(Icons.delete_forever_outlined),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: DynamicHeightGridView(
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  builder: (context, index) {
                    return ProductWidget(
                      productId: wishListProvider.getWishLists.values
                          .toList()[index]
                          .productId,
                    );
                  },
                  itemCount: wishListProvider.getWishLists.length,
                  crossAxisCount: 2),
            ),
          );
  }
}
