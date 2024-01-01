import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/providers/order_provider.dart';
import 'package:flutter_ecomerce_app/root_screen.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/orders/orders_widget.dart';
import 'package:flutter_ecomerce_app/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RootScreen()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Order',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: orderProvider.orders.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ChangeNotifierProvider.value(
                        value: orderProvider.orders.values.toList()[index],
                        child: const OrderWidget(),
                      ),
                      if (index != orderProvider.orders.length - 1)
                        const SizedBox(
                          height: 10,
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(
              height: kBottomNavigationBarHeight + 10,
            ),
          ],
        ),
      ),
    );
  }
}
