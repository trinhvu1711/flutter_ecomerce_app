import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/screens/cart/bottom_checkout.dart';
import 'package:flutter_ecomerce_app/screens/cart/cart_widget.dart';
import 'package:flutter_ecomerce_app/services/assets_manager.dart';
import 'package:flutter_ecomerce_app/widgets/empty_bag.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: const CartBottomSheetWidget(),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "${AssetsManager.shoppingCart}",
          ),
        ),
        title: const Text("Cart(6)"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_forever_outlined),
          ),
        ],
      ),
      body: isEmpty
          ? EmptyBagWidget(
              imagePath: AssetsManager.shoppingBasket,
              title: "Your cart is empty",
              subTitle:
                  "Looks Like your cart is empty add \n something and make me happy",
              buttonText: "Shop now")
          : Scaffold(
              body: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const CartWidget();
                },
              ),
            ),
    );
  }
}
