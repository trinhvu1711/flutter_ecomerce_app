import 'dart:convert';
import 'package:flutter_ecomerce_app/const/app_constants.dart';
import 'package:flutter_ecomerce_app/models/cart_model.dart';
import 'package:flutter_ecomerce_app/models/product_model.dart';
import 'package:flutter_ecomerce_app/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

// call api example
  Future<http.Response> fetchData(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Register
  Future<http.Response> registerUser(Map<String, dynamic> data) async {
    return await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
  }

  // Login
  Future<http.Response> loginUser(Map<String, dynamic> data) async {
    return await http.post(
      Uri.parse('$baseUrl/auth/authenticate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
  }

  // get access token
  Future<http.Response> getAccessToken(String bearerToken) async {
    return await http.post(
      Uri.parse('$baseUrl/auth/refresh-token'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );
  }

  // get user info
  Future<User?> getUserInfo(String bearerToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/info'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // logout user
  Future<void> logOutUser(String bearerToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );

      if (response.statusCode == 200) {
        print("logout success");
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // get product info
  Future<List<ProductModel>?> getProductInfo() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<ProductModel> products =
            data.map((item) => ProductModel.fromJson(item)).toList();
        return products;
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // create product info
  Future<ProductModel?> createProduct(
      String bearerToken, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 202) {
        Map<String, dynamic> data = json.decode(response.body);
        return ProductModel.fromJson(data);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<String?> uploadImage(XFile image) async {
    String filePath = image.path;
    try {
      final url = Uri.parse(
          'https://api.cloudinary.com/v1_1/${AppConstants.cloudName}/image/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = AppConstants.uploadPreset
        ..files.add(
          await http.MultipartFile.fromPath('file', filePath),
        );
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        return jsonMap['url'];
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  // add cart
  Future<void> addCart(String bearerToken, Map<String, dynamic> data) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/cart'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

// get cart user
  Future<List<CartModel>?> getCart(String bearerToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cart'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<CartModel> carts =
            data.map((item) => CartModel.fromJson(item)).toList();
        return carts;
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
