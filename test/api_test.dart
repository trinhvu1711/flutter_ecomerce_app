import 'dart:convert';
import 'package:flutter_ecomerce_app/models/order_model.dart';
import 'package:flutter_ecomerce_app/providers/shipping_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
// Create an instance of StatusShippingProvider
  var statusShippingProvider = StatusShippingProvider();

  test('description', () {
    // Test case 1: Matching ID
    String status1 = statusShippingProvider.getStatusByID('2');
    print('Test Case 1: $status1'); // Expected output: On the way
  });

  // Test case 2: Non-matching ID
  String status2 = statusShippingProvider.getStatusByID('06');
  print('Test Case 2: $status2'); // Expected output: Not Found

  test('Test getOrder API', () async {
    // Arrange
    final baseUrl = 'http://localhost:8080/api/v1';
    final bearerToken =
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0cmluaGxvbmd2dTEyM0BnbWFpbC5jb20iLCJpYXQiOjE3MDQyNzU1OTQsImV4cCI6MTcwNDM2MTk5NH0.XqUWJpSOp0gy4-e6YGRz9Em0GbIHBFBJ7aMwLYL30Qk';

    // Act
    final List<OrderModel>? orders = await getOrder(baseUrl, bearerToken);

    // Assert
    expect(orders, isNotNull);
    expect(orders!.isNotEmpty, true);

    // Print order details (for debugging purposes)
    orders.forEach((order) {
      print('Order ID: ${order.orderId}');
      print(
          'Location:  ${utf8.decode(order.location!.city.runes.toList())}, ${utf8.decode(order.location!.district.runes.toList())}');
      // Add more details based on your OrderModel structure
    });
  });
}

Future<List<OrderModel>?> getOrder(String baseUrl, String bearerToken) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/order'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<OrderModel> orders = data.map((item) {
        return OrderModel.fromJson(item);
      }).toList();
      return orders;
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
