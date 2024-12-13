import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/auth/login_request.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';

class LoginRepository {
  final AuthService authService = AuthService();

  Future<Map<dynamic, dynamic>?> login(LoginRequest request) async {
    final response = await authService.login(request);
    if (response['success'] == true) {
      return response;
    } else {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(const SnackBar(content: Text("Lỗi đăng nhập")));
      return null;
    }
  }
}
