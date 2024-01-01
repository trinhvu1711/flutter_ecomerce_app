import 'package:flutter/material.dart';

class PaymentMethodModel extends ChangeNotifier {
  final String id;
  final String method;

  PaymentMethodModel({required this.id, required this.method});
}
