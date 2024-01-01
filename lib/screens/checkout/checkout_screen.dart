import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/providers/cart_provider.dart';
import 'package:flutter_ecomerce_app/screens/checkout/address_widget.dart';
import 'package:flutter_ecomerce_app/screens/checkout/bottom_checkout_widget.dart';
import 'package:flutter_ecomerce_app/screens/checkout/orderItems_widget.dart';
import 'package:flutter_ecomerce_app/screens/checkout/payment_widget.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Check Out',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddressWidget(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartProvider.getCartItems.length,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                  value: cartProvider.getCartItems.values.toList()[index],
                  child: const ItemsWidget(),
                );
              },
            ),
            const PaymentWidget(),
            const SizedBox(
              height: kBottomNavigationBarHeight + 30,
            ),
          ],
        ),
      ),
      bottomSheet: const BottomCheckOutWidget(),
    );
  }
}
