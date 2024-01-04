import 'dart:convert';

import 'package:flutter/material.dart';

class LocationModel extends ChangeNotifier {
  final String city;
  final String district;
  final String ward;
  final String name;
  final String phone;
  final String addressDetails;
  late final String locationId;
  final bool removed;
  LocationModel({
    required this.name,
    required this.phone,
    required this.city,
    required this.district,
    required this.ward,
    required this.addressDetails,
    required this.locationId,
    required this.removed,
  });

// Add the fromJson factory method
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: utf8.decode(json['name'].codeUnits) ?? '',
      phone: utf8.decode(json['phone'].toString().codeUnits) ?? '',
      city: utf8.decode(json['city'].toString().codeUnits) ?? '',
      district: utf8.decode(json['district'].codeUnits) ?? '',
      ward: utf8.decode(json['ward'].codeUnits) ?? '',
      addressDetails: utf8.decode(json['address_detail'].codeUnits) ?? '',
      locationId: json['id'].toString(),
      removed: json['removed'] as bool ?? true,
    );
  }
  // Add the toJson instance method
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'city': city,
      'district': district,
      'ward': ward,
      'address_detail': addressDetails,
      'id': int.parse(locationId),
    };
  }

  // Override the toString method
  @override
  String toString() {
    return 'city: $city, '
        'district: $district, '
        'ward: $ward';
  }
}
