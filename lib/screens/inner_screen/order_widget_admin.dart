import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/order_model.dart';
import 'package:flutter_ecomerce_app/providers/products_provider.dart';
import 'package:flutter_ecomerce_app/providers/shipping_provider.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/order_detail_screen_admin.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/orders/orderdetails_screen.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class OrderWidgetAdmin extends StatelessWidget {
  const OrderWidgetAdmin({Key? key, required this.orderModel})
      : super(key: key);

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
            builder: (context) =>
                OrderDetailsScreenAdmin(orderModel: orderModel),
          ),
        );
      },
      child: Container(
        color: newColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(IconlyLight.bag),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Processing',
                          style: Theme.of(context).textTheme.bodyLarge!.apply(
                                color: Colors.blueAccent,
                                fontWeightDelta: 1,
                              ),
                        ),
                        Text(
                            shippingProvider
                                .getStatusByID(orderModel.statusShipping!),
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ),
                  const Icon(IconlyLight.arrowRight2),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(IconlyLight.ticket),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Order',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              Text('[${orderModel.orderId}]',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(IconlyLight.calendar),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Shipping Date',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              Text('07 Nov 2024',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
