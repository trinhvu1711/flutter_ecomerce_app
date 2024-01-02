import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/providers/bill_provider.dart';
import 'package:flutter_ecomerce_app/providers/cart_provider.dart';
import 'package:flutter_ecomerce_app/providers/location_provider.dart';
import 'package:flutter_ecomerce_app/providers/order_provider.dart';
import 'package:flutter_ecomerce_app/providers/paymentMethod_provider.dart';
import 'package:flutter_ecomerce_app/providers/products_provider.dart';
import 'package:flutter_ecomerce_app/providers/shipping_provider.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/orders/orders_screen.dart';
import 'package:flutter_ecomerce_app/widgets/subtitle_text.dart';
import 'package:flutter_ecomerce_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class BottomCheckOutWidget extends StatelessWidget {
  const BottomCheckOutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final billProvider = Provider.of<BillProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);
    final statusProvider = Provider.of<StatusShippingProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final paymentProvider = Provider.of<PaymentMethodProvider>(context);
    var message = '';
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(
          top: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: kBottomNavigationBarHeight + 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                        child: TitleTextWidget(
                            label:
                                "Total (${cartProvider.getCartItems.length} products/${cartProvider.getQty()} items)")),
                    SubtitleTextWidget(
                      label: "${billProvider.totalCost.toStringAsFixed(2)}\$",
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  statusProvider.setChooseMethod('01');
                  message = orderProvider.validateOrder(
                      cart: cartProvider,
                      location: locationProvider,
                      payment: paymentProvider,
                      status: statusProvider);
                  if (message == 'All values are valid') {
                    orderProvider.addOrder(
                        cart: cartProvider,
                        location: locationProvider,
                        payment: paymentProvider,
                        status: statusProvider,
                        productCost: cartProvider.getTotal(
                            productProvider: productProvider),
                        totalCost: billProvider.totalCost);
                    cartProvider.clearLocalCart();
                    cartProvider.clearCartDB(context: context);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const MyOrderScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: Colors.red[400],
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: const Text("Pay"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
