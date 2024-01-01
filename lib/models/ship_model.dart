import 'package:flutter/material.dart';

class StatusShippingModel extends ChangeNotifier {
  final String id;
  final String status;

  StatusShippingModel({required this.id, required this.status});
}
