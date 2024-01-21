import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/providers/order_provider.dart';
import 'package:flutter_ecomerce_app/root_screen.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/order_widget_admin.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/orders/orders_widget.dart';
import 'package:flutter_ecomerce_app/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class OrderScreenAdmin extends StatelessWidget {
  static const routeName = "/OrderScreenAdmin";
  const OrderScreenAdmin({super.key});
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: true);
    orderProvider.fetchAllOrder();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders Management',
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
                if (orderProvider.allOrders.values.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ChangeNotifierProvider.value(
                          value: orderProvider.allOrders.values.toList()[index],
                          child: OrderWidgetAdmin(
                            orderModel:
                                orderProvider.allOrders.values.toList()[index],
                          ),
                        ),
                        if (index != orderProvider.allOrders.length - 1)
                          const SizedBox(
                            height: 2,
                          ),
                      ],
                    ),
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
