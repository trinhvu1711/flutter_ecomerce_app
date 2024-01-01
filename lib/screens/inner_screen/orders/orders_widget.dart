import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/order_model.dart';
import 'package:flutter_ecomerce_app/providers/products_provider.dart';
import 'package:flutter_ecomerce_app/providers/shipping_provider.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/orders/orderdetails_screen.dart';
import 'package:provider/provider.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final orderModel = Provider.of<OrderModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getFirstProduct =
        productProvider.findByProdId(orderModel.cartItem[0].productId);
    final shippingProvider = Provider.of<StatusShippingProvider>(context);

    // Tạo màu mới dựa trên màu nền hiện tại
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

    return getFirstProduct == null
        ? const SizedBox.shrink()
        : GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OrderDetailsScreen(orderModel: orderModel),
                ),
              );
            },
            child: Container(
              color: newColor, // Sử dụng màu mới ở đây
              child: Column(
                children: [
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FancyShimmerImage(
                        imageUrl: getFirstProduct.productImage,
                        height: size.height * 0.2,
                        width: size.width * 0.2,
                      ),
                    ),
                    title: Text(getFirstProduct.productTitle),
                    subtitle: Text(getFirstProduct.productPrice.toString()),
                    trailing: Text('x${orderModel.cartItem[0].quantity}'),
                  ),
                  Divider(color: lineColor),
                  ListTile(
                    leading: Text(
                      'Items: ${orderModel.getQtyItems()}\nStatus: ${shippingProvider.getStatusByID(orderModel.statusShipping)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      'Total cost: ${orderModel.totalCost}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ));
  }
}
