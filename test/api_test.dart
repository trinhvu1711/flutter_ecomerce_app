import 'package:flutter_ecomerce_app/models/user_model.dart';
import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('getUserInfoTest returns a User object on successful response',
      () async {
    // Arrange
    final apiService = ApiService();
    const bearerToken =
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtYW5hZ2VyQG1haWwuY29tIiwiaWF0IjoxNzAyMzUxOTAyLCJleHAiOjE3MDI0MzgzMDJ9.PC0eu9zMTWk3_FgUa3yhwmzuSKVGFTuUMKB-x7Q-yzw'; // Thay đổi giá trị này với token thực tế

    // Act
    final user = await apiService.getUserInfoTest(bearerToken);
    print('User Name: ${user.userName}');
    print('User Email: ${user.userEmail}');
    // Assert
    expect(user, isA<User>());
    expect(user.userName,
        isNotEmpty); // Kiểm tra rằng thuộc tính 'name' không rỗng
    expect(user.userEmail,
        isNotEmpty); // Kiểm tra rằng thuộc tính 'email' không rỗng
  });

  test('getUserInfoTest returns an error on unsuccessful response', () async {
    // Arrange
    final apiService = ApiService();
    final invalidToken =
        'invalid_token'; // Thay đổi giá trị này với token không hợp lệ

    // Act
    try {
      await apiService.getUserInfoTest(invalidToken);
    } catch (error) {
      // Assert
      expect(error, isA<Exception>());
      expect(error.toString(), 'Failed to load user info');
    }
  });

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
}
