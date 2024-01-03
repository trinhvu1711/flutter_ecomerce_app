import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/location_model.dart';
import 'package:flutter_ecomerce_app/models/user_model.dart';
import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:flutter_ecomerce_app/services/auth_service.dart';
import 'package:flutter_ecomerce_app/services/my_app_function.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationProvider with ChangeNotifier {
  LocationModel? _consumeLocation;
  LocationModel? get consumeLocation => _consumeLocation;

  void setConsumeLocation(LocationModel value) {
    _consumeLocation = value;
    notifyListeners();
  }

  LocationModel? _locationItems;
  LocationModel? get locationItems {
    return _locationItems;
  }

  // add to location database
  Future<void> addToLocationtDB({
    required LocationModel locationModel,
    required BuildContext context,
  }) async {
    final apiService = ApiService();
    final authService = AuthService();
    bool isLoggedIn = await authService.isLoggedInAndRefresh(apiService);
    final token = await authService.getToken();
    final User? user = await apiService.getUserInfo(token!);
    if (user == null || !isLoggedIn) {
      MyAppFunction.showErrorOrWarningDialog(
        context: context,
        subtitle: "Please login first",
        fct: () {},
      );
      return;
    }
    Map<String, dynamic> data = locationModel.toJson();

    try {
      await apiService.addAddress(token, data);

      Fluttertoast.showToast(msg: "Address has been added");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAddress() async {
    final apiService = ApiService();
    final authService = AuthService();
    bool isLoggedIn = await authService.isLoggedInAndRefresh(apiService);
    final token = await authService.getToken();
    if (token == null) return;
    final User? user = await apiService.getUserInfo(token);

    if (user == null || !isLoggedIn) {
      return;
    }
    try {
      final data = await apiService.getAddressList(token);

      if (data?.isNotEmpty == true) {
        // Check if the list has elements
        _locationItems = data!.first;
      } else {
        // Handle the case when the list is empty
        print('The list is empty.');
      }
    } catch (e) {
      print(e.toString());
    }
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
}
