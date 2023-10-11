import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/widgets/title_text.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: TitleTextWidget(label: "CartScreen"),
      ),
    );
  }
}
