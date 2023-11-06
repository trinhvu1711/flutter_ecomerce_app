import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/providers/viewed_recently_provider.dart';
import 'package:flutter_ecomerce_app/services/assets_manager.dart';
import 'package:flutter_ecomerce_app/widgets/empty_bag.dart';
import 'package:flutter_ecomerce_app/widgets/products/product_widget.dart';
import 'package:provider/provider.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  static const routName = "/ViewedRecentlyScreen";
  const ViewedRecentlyScreen({Key? key}) : super(key: key);
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    final viewedProvider = Provider.of<ViewedProdvider>(context);
    return viewedProvider.getViewedProds.isEmpty
        ? EmptyBagWidget(
            imagePath: AssetsManager.orderBag,
            title: "No viewed product yet",
            subTitle:
                "Looks Like your cart is empty add \n something and make me happy",
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
              title: Text(
                  "View recently(${viewedProvider.getViewedProds.length})"),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_forever_outlined),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: DynamicHeightGridView(
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                builder: (context, index) {
                  return ProductWidget(
                    productId: viewedProvider.getViewedProds.values
                        .toList()[index]
                        .productId,
                  );
                },
                itemCount: viewedProvider.getViewedProds.length,
                crossAxisCount: viewedProvider.getViewedProds.length,
              ),
            ),
          );
  }
}
