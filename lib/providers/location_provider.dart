import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/location_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationProvider with ChangeNotifier {
  LocationModel? _consumeLocation;
  LocationModel? get consumeLocation => _consumeLocation;
  String _name = '';
  String _phone = '';
  String _city = '';
  String _cityCode = '';
  String _district = '';
  String _districtCode = '';
  String _ward = '';
  String _addressDetails = '';

  String get name => _name;
  String get phone => _phone;
  String get city => _city;
  String get cityCode => _cityCode;
  String get district => _district;
  String get districtCode => _districtCode;
  String get ward => _ward;
  String get addressDetails => _addressDetails;

  void setCity(String city, String cityCode) {
    _city = city;
    _cityCode = cityCode;
    notifyListeners();
  }

  void setDistrict(String district, String districtCode) {
    _district = district;
    _districtCode = districtCode;
    notifyListeners();
  }

  void setWard(String ward) {
    _ward = ward;
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  void setAddressDetails(String addressDetails) {
    _addressDetails = addressDetails;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> fetchLocations(String url) async {
    final response = await http.get(Uri.parse(url));
    String decodedResponse = convert.utf8.decode(response.bodyBytes);
    List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(convert.json.decode(decodedResponse));
    return data
        .map((item) => {'name': item['name'], 'code': item['code'].toString()})
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchDistricts(String url) async {
    final response = await http.get(Uri.parse(url));
    String decodedResponse = convert.utf8.decode(response.bodyBytes);
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        convert.json.decode(decodedResponse)['districts']);
    return data
        .map((item) => {'name': item['name'], 'code': item['code'].toString()})
        .toList();
  }

  Future<List<String>> fetchWards(String url) async {
    final response = await http.get(Uri.parse(url));
    String decodedResponse = convert.utf8.decode(response.bodyBytes);
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        convert.json.decode(decodedResponse)['wards']);
    return data.map((item) => item['name'].toString()).toList();
  }

  bool isEmptyField() {
    return _name.isEmpty ||
        _phone.isEmpty ||
        _city.isEmpty ||
        _cityCode.isEmpty ||
        _district.isEmpty ||
        _districtCode.isEmpty ||
        _ward.isEmpty ||
        _addressDetails.isEmpty;
  }

  void addLocation(
      {required String name,
      required String phone,
      required String city,
      required String district,
      required String ward,
      required String addressDetails}) {
    _consumeLocation = LocationModel(
        name: name,
        phone: phone,
        city: city,
        district: district,
        ward: ward,
        addressDetails: addressDetails);
    notifyListeners();
  }
}
