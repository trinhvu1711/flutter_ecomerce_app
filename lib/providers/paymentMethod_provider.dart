import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/paymentmethod_model.dart';

class PaymentMethodProvider extends ChangeNotifier {
  String _chooseMethod = '';
  final List<PaymentMethodModel> _paymentMethods = [
    PaymentMethodModel(id: '01', method: 'Payment on delivery'),
    PaymentMethodModel(id: '02', method: 'Banking'),
    PaymentMethodModel(id: '03', method: 'Momo'),
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
