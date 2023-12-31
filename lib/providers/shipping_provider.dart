import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/ship_model.dart';

class StatusShippingProvider extends ChangeNotifier {
  String _statusOrder = '';
  final List<StatusShippingModel> _statusShippings = [
    StatusShippingModel(id: '01', status: 'Comfirmed'),
    StatusShippingModel(id: '02', status: 'On the way'),
    StatusShippingModel(id: '03', status: 'Dispatched for delivery'),
    StatusShippingModel(id: '04', status: 'Delivered '),
    StatusShippingModel(id: '05', status: 'Delivery failed'),
  ];

  List<StatusShippingModel> get statusShipping => _statusShippings;
  String get statusOrder => _statusOrder;
  void setChooseMethod(String value) {
    _statusOrder = value;
    notifyListeners();
  }

  String getStatusByID(String id) {
    if (statusShipping.where((element) => element.id == id).isEmpty) {
      return '';
    }
    return statusShipping.firstWhere((element) => element.id == id).status;
  }
}
