import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/order_model.dart';
import 'package:flutter_ecomerce_app/providers/products_provider.dart';
import 'package:flutter_ecomerce_app/providers/shipping_provider.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/orders/orderdetails_screen.dart';
import 'package:provider/provider.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget({Key? key, required this.orderModel}) : super(key: key);

  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final String? productId = orderModel.cartItem.isNotEmpty
        ? orderModel.cartItem.first.productId
        : null;

    if (productId == null) {
      return SizedBox.shrink();
    }

    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    final StatusShippingProvider shippingProvider =
        Provider.of<StatusShippingProvider>(context);

    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final hslColor = HSLColor.fromColor(backgroundColor);
    final newColor = hslColor
        .withLightness(
            hslColor.lightness + (hslColor.lightness < 0.5 ? 0.05 : -0.05))
        .toColor();
    final lineColor = hslColor
        .withLightness(
            hslColor.lightness + (hslColor.lightness < 0.5 ? 0.0 : -0.0))
        .toColor();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(orderModel: orderModel),
          ),
        );
      },
      child: Container(
        color: newColor,
        child: Column(
          children: [
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FancyShimmerImage(
                  imageUrl:
                      productProvider.findByProdId(productId)!.productImage,
                  height: size.height * 0.2,
                  width: size.width * 0.2,
                ),
              ),
              title: Text(
                productProvider.findByProdId(productId)!.productTitle,
              ),
              subtitle: Text(
                productProvider
                    .findByProdId(productId)!
                    .productPrice
                    .toString(),
              ),
              trailing: Text('x${orderModel.cartItem[0].quantity}'),
            ),
            Divider(color: lineColor),
            ListTile(
              leading: Text(
                'Items: ${orderModel.getQtyItems()}\nStatus: ${shippingProvider.getStatusByID(orderModel.statusShipping!)}',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Text(
                'Total cost: ${orderModel.totalCost}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
