import 'package:flutter/material.dart';

class BillProvider extends ChangeNotifier {
  double _totalCost = 0.0;

  double get totalCost => _totalCost;

  setTotalCost(double cost) {
    _totalCost = cost;
    notifyListeners();
  }
}
