import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/paymentmethod_model.dart';

class PaymentMethodProvider extends ChangeNotifier {
  String _chooseMethod = '';
  final List<PaymentMethodModel> _paymentMethods = [
    PaymentMethodModel(id: '1', method: 'Payment on delivery'),
    PaymentMethodModel(id: '2', method: 'Banking'),
    PaymentMethodModel(id: '3', method: 'Momo'),
  ];

  List<PaymentMethodModel> get paymentMethod => _paymentMethods;
  String get chooseMethod => _chooseMethod;
  void setChooseMethod(String value) {
    _chooseMethod = value;
    notifyListeners();
  }

  String getMethodByID(String id) {
    if (paymentMethod.where((element) => element.id == id).isEmpty) {
      return '';
    }
    return paymentMethod.firstWhere((element) => element.id == id).method;
  }
}
