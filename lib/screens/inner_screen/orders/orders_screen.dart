import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/providers/order_provider.dart';
import 'package:flutter_ecomerce_app/root_screen.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/orders/orders_widget.dart';
import 'package:flutter_ecomerce_app/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({super.key});
  static const routeName = "/OrderScreen";
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: true);
    return Scaffold(
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
                if (orderProvider.orders.values.isNotEmpty) {
                  return Column(
                    children: [
                      ChangeNotifierProvider.value(
                        value: orderProvider.orders.values.toList()[index],
                        child: OrderWidget(
                          orderModel:
                              orderProvider.orders.values.toList()[index],
                        ),
                      ),
                      if (index != orderProvider.orders.length - 1)
                        const SizedBox(
                          height: 10,
                        ),
                    ],
                  );
                } else {
                  return Container(); // or any other widget you want to show when the list is empty
                }
              },
            ),
          ),
          const SizedBox(
            height: kBottomNavigationBarHeight + 10,
          ),
        ],
      ),
    );
  }
}
