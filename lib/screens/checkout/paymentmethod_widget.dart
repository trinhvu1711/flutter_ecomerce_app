import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/providers/paymentMethod_provider.dart';
import 'package:provider/provider.dart';

class PaymentMethodWidget extends StatelessWidget {
  const PaymentMethodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var payment = Provider.of<PaymentMethodProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
            shrinkWrap:
                true, // giúp ListView.builder chỉ chiếm không gian cần thiết
            itemCount: payment.paymentMethod.length,
            itemBuilder: (context, index) {
              return RadioListTile(
                value: payment.paymentMethod[index].id,
                groupValue: payment.chooseMethod,
                onChanged: (String? value) {
                  payment.setChooseMethod(value!);
                },
                title: Text(payment.paymentMethod[index].method),
              );
            },
          ),
          ElevatedButton(
              onPressed: () {
                if (payment.chooseMethod.isNotEmpty) {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Please choose a payment method'),
                      backgroundColor: Colors.red[400],
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Save')),
        ],
      ),
    );
  }
}
