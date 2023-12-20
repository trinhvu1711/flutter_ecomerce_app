import 'dart:convert';

import 'package:flutter_ecomerce_app/models/user_model.dart';
import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test upload image', () async {
    // Arrange
    final apiService = ApiService();
    try {
      final String url = await apiService.uploadImageTest();
      print('url ' + url);
    } catch (error) {
      // Assert
      expect(error, isA<Exception>());
      expect(error.toString(), 'Failed to upload image');
    }
  });

  test('test get access token', () async {
    // Arrange
    final apiService = ApiService();
    try {
      final response = await apiService.getAccessTokenTest(
          "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbkBtYWlsLmNvbSIsImlhdCI6MTcwMjY4NzI2MiwiZXhwIjoxNzAzMjkyMDYyfQ.hitiZm89b5dG_iRIOZxesefjRi1tb9Jvdjgftjm9XEE");
      String token = json.decode(response.body)['access_token'];
      print('token' + token);
    } catch (error) {
      // Assert
      expect(error, isA<Exception>());
      expect(error.toString(), 'Failed to upload image');
    }
  });

  test('test create product', () async {
    // Arrange
    final apiService = ApiService();
    try {
      final data = {
        "id": 4,
        "name": "Updated Product",
        "description": "An updated description",
        "category": null,
        "price": 59.99,
        "quantity": 0,
        "img": null
      };
      await apiService.createProductTest(
          "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbkBtYWlsLmNvbSIsImlhdCI6MTcwMjkxMTcxNiwiZXhwIjoxNzAyOTk4MTE2fQ.9BuCFLaiynQQqP7i3z_wfHaCyEcORMTZvFSBRiIYDuU",
          data);
    } catch (error) {
      // Assert
      expect(error, isA<Exception>());
      expect(error.toString(), 'Failed to create product');
    }
  });

  test('test view product', () async {
    // Arrange
    final apiService = ApiService();
    try {
      final products = await apiService.getProductInfoTest();
      print(products);
    } catch (error) {
      // Assert
      expect(error, isA<Exception>());
      expect(error.toString(), 'Failed to create product');
    }
  });
}
