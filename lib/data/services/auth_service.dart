import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/env.dart';
import 'package:restaurant_manager_mobile/data/models/user_modal.dart';
import 'dart:convert';

class AuthService {
  static const String baseUrl = Env.apiUrl;

    Future<Map> signUp(UserModel user) async {
    try {
      final response = await ApiClient.post('/account/register', body: user.toJson());
      
      if (response['success'] == true) {
        return _createResponse(
          success: true,
          data: response['data'],
          message: response['message']
        );
      }

      return _createResponse(
        success: false,
        message: response['message']
      );

    } catch (e) {
      return _createResponse(
        success: false,
        message: '$e',
        error: 'Lỗi hệ thống!'
      );
    }
  }

  Future<Map> sendOTP(String phone) async {
    try {
      final response = await ApiClient.post('/otp/sendOTP', body: {
        'phone': phone
      });
      print(response);
      if (response['success']) {
        return _createResponse(
          success: true,
          data: response['data'],
          message: response['message']
        );
      }
      return _createResponse(
        success: false,
        message: response['message']
      );
    } catch (e) {
      return _createResponse(
        success: false,
        message: '$e',
        error: 'Lỗi hệ thống!'
      );
    }
  }

  Future<Map> verifyPhone(String phone, String code) async {
    try {
      final response = await ApiClient.post('/otp/activeOTP', body: {
        'phone': phone,
        'code': code
      });
      return {
        'success': true,
        'data': response['data'],
        'message': response['message']
      };
    } catch (e) {
      return _createResponse(
        success: false,
        message: '$e',
        error: 'Lỗi hệ thống!'
      );
    }
  }

  Future<Map> getPhone(String username, String password) async {
    try {
      final String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      final response = await ApiClient.post(
        '/account/get-phone',
        headers: {
          'Authorization': basicAuth,
        }
      );

      return _createResponse(
        success: true,
        data: response['data'],
        message: response['message']
      );
      
    } catch (e) {
      return _createResponse(
        success: false,
        message: '$e',
        error: 'Lỗi hệ thống!'
      );
    }
  }

  Future<Map> login(UserModel user) async {
    try {
      final response = await ApiClient.post('/account/login', body: user.toLoginJson());
      
      if (response['success'] == true) {
        return {
          'success': true,
          'data': response['data'],
          'message': response['message']
        };
      }

      // Xử lý các trường hợp lỗi
      if (response['error'] == "Account not activated") {
        return _createResponse(
          success: true,
          message: 'Tài khoản của bạn chưa được kích hoạt',
          status: 'inactive'
        );
      }

      if (response['statusCode'] == "Unauthorized") {
        return _createResponse(
          success: false,
          message: 'Tên đăng nhập hoặc mật khẩu không đúng'
        );
      }

      return _createResponse(
        success: false,
        message: response['message']
      );

    } catch (e) {
      return _createResponse(
        success: false,
        message: '$e',
        error: 'Lỗi hệ thống!'
      );
    }
  }

  // Helper method để tạo response
  Map _createResponse({
    required bool success,
    String? message,
    String? status,
    String? error,
    dynamic data,
  }) {
    final response = {};
    response['success'] = success;
    if (message != null) response['message'] = message;
    if (status != null) response['status'] = status;
    if (error != null) response['error'] = error;
    if (data != null) response['data'] = data;
    return response;
  }
}
