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
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      ward: json['ward'] ?? '',
      addressDetails: json['address_detail'] ?? '',
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
