import 'package:flutter/material.dart';

class LocationModel extends ChangeNotifier {
  final String city;
  final String district;
  final String ward;
  final String name;
  final String phone;
  final String addressDetails;

  LocationModel(
      {required this.name,
      required this.phone,
      required this.city,
      required this.district,
      required this.ward,
      required this.addressDetails});
}
