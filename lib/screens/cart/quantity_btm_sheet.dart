import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/cart_model.dart';
import 'package:flutter_ecomerce_app/providers/cart_provider.dart';
import 'package:flutter_ecomerce_app/widgets/subtitle_text.dart';
import 'package:provider/provider.dart';

class QuantityButtonSheetWidget extends StatelessWidget {
  const QuantityButtonSheetWidget({Key? key, required this.cartModel})
      : super(key: key);
  final CartModel cartModel;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 6,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 25,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  cartProvider.updateQty(
                      productId: cartModel.productId, qty: index + 1);
                  Navigator.pop(context);
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SubtitleTextWidget(label: "${index + 1}"),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
