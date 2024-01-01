import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/providers/bill_provider.dart';
import 'package:flutter_ecomerce_app/providers/cart_provider.dart';
import 'package:flutter_ecomerce_app/providers/location_provider.dart';
import 'package:flutter_ecomerce_app/providers/paymentMethod_provider.dart';
import 'package:flutter_ecomerce_app/providers/products_provider.dart';
import 'package:flutter_ecomerce_app/screens/checkout/paymentmethod_widget.dart';
import 'package:provider/provider.dart';

class PaymentWidget extends StatelessWidget {
  const PaymentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final billProvider = Provider.of<BillProvider>(context);
    final payment = Provider.of<PaymentMethodProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);
    var proCost = cartProvider.getTotal(productProvider: productProvider);
    var shippingCost = locationProvider.consumeLocation == null ? 0 : 100;
    var totalCost = proCost + shippingCost;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      billProvider.setTotalCost(totalCost);
    });

    return payment.chooseMethod.isNotEmpty == true
        ? Center(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PaymentMethodWidget()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 95,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.payment),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Payment Method',
                                    style: TextStyle(fontSize: 23),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                payment.getMethodByID(payment.chooseMethod),
                                softWrap: false,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 17),
                              )
                            ],
                          ),
                        ),
                        const Expanded(
                          flex: 5,
                          child: Icon(Icons.chevron_right_outlined),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.notes_sharp),
                          SizedBox(width: 8.0),
                          Text(
                            'Payment Details',
                            style: TextStyle(fontSize: 23),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      buildDetailRow('Total cost of goods:',
                          '${proCost.toStringAsFixed(2)}\$'),
                      buildDetailRow('Total shipping fee:',
                          '${shippingCost.toStringAsFixed(2)}\$'),
                      buildDetailRow('Total amount to be paid:',
                          '${totalCost.toStringAsFixed(2)}\$'),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PaymentMethodWidget()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 95,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.payment),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Payment Method',
                                    style: TextStyle(fontSize: 23),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Choose Payment Method',
                                softWrap: false,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 17),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Icon(Icons.chevron_right_outlined),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.notes_sharp),
                          SizedBox(width: 8.0),
                          Text(
                            'Payment Details',
                            style: TextStyle(fontSize: 23),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      buildDetailRow('Total cost of goods:',
                          '${proCost.toStringAsFixed(2)}\$'),
                      buildDetailRow('Total shipping fee:',
                          '${shippingCost.toStringAsFixed(2)}\$'),
                      buildDetailRow('Total amount to be paid:',
                          '${totalCost.toStringAsFixed(2)}\$'),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

Widget buildDetailRow(String title, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 17),
      ),
      Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    ],
  );
}
