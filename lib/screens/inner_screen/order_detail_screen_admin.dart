import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/const/app_constants.dart';
import 'package:flutter_ecomerce_app/models/order_model.dart';
import 'package:flutter_ecomerce_app/providers/order_provider.dart';
import 'package:flutter_ecomerce_app/providers/paymentMethod_provider.dart';
import 'package:flutter_ecomerce_app/screens/auth/login.dart';
import 'package:flutter_ecomerce_app/screens/checkout/orderItems_widget.dart';
import 'package:flutter_ecomerce_app/screens/checkout/payment_widget.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/orders/oderdetailsitem_widget.dart';
import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:flutter_ecomerce_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreenAdmin extends StatefulWidget {
  final OrderModel orderModel;
  const OrderDetailsScreenAdmin({Key? key, required this.orderModel})
      : super(key: key);

  @override
  State<OrderDetailsScreenAdmin> createState() =>
      _OrderDetailsScreenAdminState();
}

class _OrderDetailsScreenAdminState extends State<OrderDetailsScreenAdmin> {
  String? _statusValue;
  @override
  Widget build(BuildContext context) {
    final payment = Provider.of<PaymentMethodProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    Future<void> _updateStatusOrder() async {
      if (_statusValue == null) {
        return;
      }
      OrderModel model = widget.orderModel;
      model.statusValue = _statusValue!;
      final authService = AuthService();
      final apiService = ApiService();
      bool isLoggedIn = await authService.isLoggedInAndRefresh(apiService);
      if (!isLoggedIn) {
        Navigator.pushReplacementNamed(
          context,
          LoginScreen.routeName,
        );
      }
      orderProvider.addToOrderDB(
          orderModel: widget.orderModel, context: context);
      orderProvider.fetchAllOrder();
    }

    // print(orderModel);
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
                          '${widget.orderModel.location?.name} | ${widget.orderModel.location?.phone}',
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          '${widget.orderModel.location?.addressDetails}, ${widget.orderModel.location?.ward}, ${widget.orderModel.location?.district},${widget.orderModel.location?.city}.',
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
                itemCount: widget.orderModel.cartItem.length,
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                    value: widget.orderModel.cartItem.toList()[index],
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
                          payment
                              .getMethodByID(widget.orderModel.paymentMethodId),
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
                      '${widget.orderModel.productCost.toStringAsFixed(2)}\$'),
                  buildDetailRow('Total shipping fee:',
                      '${widget.orderModel.shippingFee.toStringAsFixed(2)}\$'),
                  buildDetailRow('Total amount to be paid:',
                      '${widget.orderModel.totalCost.toStringAsFixed(2)}\$'),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // category dropdown
            DropdownButton(
              items: AppConstants.statusOrderDropDownList,
              value: _statusValue,
              hint: Text("Choose a Category"),
              onChanged: (value) {
                print('status value $value');
                setState(() {
                  _statusValue = value;
                });
              },
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ),
                  ),
                ),
                icon: const Icon(Icons.edit),
                label: const Text("Update status"),
                onPressed: () async {
                  await _updateStatusOrder();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
