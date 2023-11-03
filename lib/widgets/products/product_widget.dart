import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/const/app_constants.dart';
import 'package:flutter_ecomerce_app/models/product_model.dart';
import 'package:flutter_ecomerce_app/providers/cart_provider.dart';
import 'package:flutter_ecomerce_app/providers/products_provider.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/product_detail.dart';
import 'package:flutter_ecomerce_app/widgets/heart_btn.dart';
import 'package:flutter_ecomerce_app/widgets/subtitle_text.dart';
import 'package:flutter_ecomerce_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    Key? key,
    required this.productId,
  }) : super(key: key);
  final String productId;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    // final productModelProvider = Provider.of<ProductModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findByProdId(widget.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    Size size = MediaQuery.of(context).size;
    return getCurrProduct == null
        ? const SizedBox.shrink()
        : GestureDetector(
            onTap: () async {
              await Navigator.pushNamed(
                context,
                ProductDetailScreen.routName,
                arguments: getCurrProduct.productId,
              );
            },
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FancyShimmerImage(
                    imageUrl: getCurrProduct.productImage,
                    height: size.height * 0.2,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 5,
                        child: TitleTextWidget(
                          label: getCurrProduct.productTitle,
                          fontSize: 18,
                          maxLines: 2,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: HeartBtn(productId: getCurrProduct.productId),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: SubtitleTextWidget(
                        label: "${getCurrProduct.productPrice}\$",
                        color: Colors.blue,
                      ),
                    ),
                    Flexible(
                      child: Material(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.0),
                          onTap: () {
                            if (cartProvider.isProductInCart(
                                productId: getCurrProduct.productId)) {
                              return;
                            }
                            cartProvider.addProductToCart(
                                productId: getCurrProduct.productId);
                          },
                          splashColor: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(cartProvider.isProductInCart(
                                    productId: getCurrProduct.productId)
                                ? Icons.check
                                : Icons.add_shopping_cart_outlined),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          );
  }
}
