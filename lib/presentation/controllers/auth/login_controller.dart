import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/repositories/auth/login_repository.dart';
import 'package:restaurant_manager_mobile/data/models/auth/login_request.dart';
import 'package:restaurant_manager_mobile/data/services/state_service.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class LoginController extends GetxController {
  final stateService = Get.find<StateService>();
  final LoginRepository repository;

  LoginController({required this.repository});

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 7 && hour < 10) {
      return 'Chào buổi sáng !!!';
    } else if (hour >= 10 && hour < 17) {
      return 'Chào buổi chiều !!!';
    } else {
      return 'Chào buổi tối !!!';
    }
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;

    final user = LoginRequest(
      username: usernameController.text,
      password: passwordController.text,
    );

    try {
      final response = await repository.login(user);
      if (response != null) {
        final storageService = await StorageService.getInstance();

        await storageService.setString(StorageKeys.username, user.username);
        await storageService.setString(StorageKeys.password, user.password);
        await storageService.setString(
            StorageKeys.userId, response['data']['id']);
        await storageService.setString(
            StorageKeys.role, response['data']['role']);
        await storageService.setString(
            StorageKeys.name, response['data']['name']);
        await storageService.setString(
            StorageKeys.statusUser, response['data']['status']);
        await storageService.setString(
            StorageKeys.restaurantId, response['data']['idRestaurant'] ?? '');
        await storageService.setString(
            StorageKeys.restaurantName, response['data']['nameRestaurant'] ?? '');
        await storageService.setString(
            StorageKeys.avt, response['data']['avt'] ?? '');
        await storageService.setString(
            StorageKeys.phone, response['data']['phone'] ?? '');
        await storageService.setString(
            StorageKeys.birthDay, response['data']['birthDay'] ?? '');
        await storageService.setBool(StorageKeys.isLogin, true);
        stateService.setAuthenticated(true);
        Get.offNamed(RouteNames.splash);
      }
    } finally {
      isLoading.value = false;
    }
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên đăng nhập';
    }
    if (value.length < 5) {
      return 'Tên đăng nhập phải có ít nhất 5 ký tự';
    }
    return null;
  }
}
