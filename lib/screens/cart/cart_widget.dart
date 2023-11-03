import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/const/app_constants.dart';
import 'package:flutter_ecomerce_app/models/cart_model.dart';
import 'package:flutter_ecomerce_app/providers/cart_provider.dart';
import 'package:flutter_ecomerce_app/providers/products_provider.dart';
import 'package:flutter_ecomerce_app/screens/cart/quantity_btm_sheet.dart';
import 'package:flutter_ecomerce_app/widgets/heart_btn.dart';
import 'package:flutter_ecomerce_app/widgets/subtitle_text.dart';
import 'package:flutter_ecomerce_app/widgets/title_text.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final cartModel = Provider.of<CartModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findByProdId(cartModel.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    return getCurrProduct == null
        ? const SizedBox.shrink()
        : FittedBox(
            child: IntrinsicWidth(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FancyShimmerImage(
                        imageUrl: getCurrProduct.productImage,
                        height: size.height * 0.2,
                        width: size.height * 0.2,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IntrinsicWidth(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.6,
                                child: TitleTextWidget(
                                  label: getCurrProduct.productTitle,
                                  maxLines: 2,
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      cartProvider.removeOneItem(
                                        productId: getCurrProduct.productId,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                    ),
                                  ),
                                  HeartBtn(productId: getCurrProduct.productId),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SubtitleTextWidget(
                                label: "${getCurrProduct.productPrice}\$",
                                color: Colors.blue,
                              ),
                              OutlinedButton.icon(
                                onPressed: () async {
                                  await showModalBottomSheet(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return QuantityButtonSheetWidget(
                                        cartModel: cartModel,
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(IconlyLight.arrowDown2),
                                label: Text("Qty: ${cartModel.quantity}"),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(width: 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ],
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
