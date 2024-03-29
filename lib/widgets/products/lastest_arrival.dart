import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/product_model.dart';
import 'package:flutter_ecomerce_app/providers/cart_provider.dart';
import 'package:flutter_ecomerce_app/providers/viewed_recently_provider.dart';
import 'package:flutter_ecomerce_app/providers/wishList_provider.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/product_detail.dart';
import 'package:flutter_ecomerce_app/services/my_app_function.dart';
import 'package:flutter_ecomerce_app/widgets/heart_btn.dart';
import 'package:flutter_ecomerce_app/widgets/subtitle_text.dart';
import 'package:provider/provider.dart';

class LastestArrivalProductWidget extends StatelessWidget {
  const LastestArrivalProductWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedProvider = Provider.of<ViewedProdvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          viewedProvider.addViewedProd(productId: productModel.productId);
          await Navigator.pushNamed(context, ProductDetailScreen.routName,
              arguments: productModel.productId);
        },
        child: SizedBox(
          width: size.width * 0.45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: FancyShimmerImage(
                    imageUrl: productModel.productImage,
                    height: size.width * 0.24,
                    width: size.width * 0.32,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      productModel.productTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          HeartBtn(productId: productModel.productId),
                          IconButton(
                            onPressed: () async {
                              if (cartProvider.isProductInCart(
                                  productId: productModel.productId)) {
                                return;
                              }
                              try {
                                await cartProvider.addToCartDB(
                                    productId: productModel.productId,
                                    qty: 1,
                                    context: context);
                              } catch (e) {
                                await MyAppFunction.showErrorOrWarningDialog(
                                  context: context,
                                  subtitle: e.toString(),
                                  fct: () {},
                                );
                              }
                            },
                            icon: Icon(
                              cartProvider.isProductInCart(
                                      productId: productModel.productId)
                                  ? Icons.check
                                  : Icons.add_shopping_cart_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FittedBox(
                      child: SubtitleTextWidget(
                        label: "${productModel.productPrice}\$",
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
