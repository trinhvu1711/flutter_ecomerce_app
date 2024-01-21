import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/order_model.dart';
import 'package:flutter_ecomerce_app/providers/paymentMethod_provider.dart';
import 'package:flutter_ecomerce_app/screens/checkout/orderItems_widget.dart';
import 'package:flutter_ecomerce_app/screens/checkout/payment_widget.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/orders/oderdetailsitem_widget.dart';
import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:flutter_ecomerce_app/services/auth_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel orderModel;
  const OrderDetailsScreen({Key? key, required this.orderModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final payment = Provider.of<PaymentMethodProvider>(context);
    print(orderModel);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Detail',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.share_location_outlined),
                            SizedBox(width: 8.0),
                            Text(
                              'Delivery Address',
                              style: TextStyle(fontSize: 23),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          '${orderModel.location?.name} | ${orderModel.location?.phone}',
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          '${orderModel.location?.addressDetails}, ${orderModel.location?.ward}, ${orderModel.location?.district},${orderModel.location?.city}.',
                          softWrap: false,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 17),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderModel.cartItem.length,
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                    value: orderModel.cartItem.toList()[index],
                    child: const OrderDetailsItemWidget(),
                  );
                }),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
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
                          payment.getMethodByID(orderModel.paymentMethodId),
                          softWrap: false,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 17),
                        )
                      ],
                    ),
                  ),
                ],
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
                      '${orderModel.productCost.toStringAsFixed(2)}\$'),
                  buildDetailRow('Total shipping fee:',
                      '${orderModel.shippingFee.toStringAsFixed(2)}\$'),
                  buildDetailRow('Total amount to be paid:',
                      '${orderModel.totalCost.toStringAsFixed(2)}\$'),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () async {
                      final apiService = ApiService();
                      final authService = AuthService();
                      bool isLoggedIn =
                          await authService.isLoggedInAndRefresh(apiService);
                      final token = await authService.getToken();
                      if (token == null) return;
                      print("id order" + orderModel.orderId);
                      await apiService.cancelOrder(token, orderModel.orderId);
                      Fluttertoast.showToast(
                        msg: "Cancel order successfull ",
                        textColor: Colors.white,
                      );
                    },
                    child: const Text("Cancel Order"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
