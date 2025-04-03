import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/auth/login_request.dart';
import 'package:restaurant_manager_mobile/data/repositories/auth/login_repository.dart';
import 'package:restaurant_manager_mobile/data/services/state_service.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class LoginController extends GetxController {
  final stateService = Get.find<StateService>();
  final LoginRepository repository;

  LoginController(
      {required this.repository});

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
        final storageService = await StorageService.getInstance();
        if (response != null) {
          await storageService.setString(
              StorageKeys.token, response['data']['result']['token']);
          await storageService.setBool(StorageKeys.isLogin, true);
          await storageService.setString(StorageKeys.username, usernameController.text);
          await storageService.setString(StorageKeys.password, passwordController.text);
          stateService.setAuthenticated(true);
          Get.offNamed(RouteNames.splash);

          // Get my info
          // final responseMyInfo = await repository.getMyInfo();
          // print("responseMyInfo: ${responseMyInfo}");
          // if (responseMyInfo != null) {
          //   final token = responseMyInfo['data']['result']['token'];
          //   idAccount = responseMyInfo['data']['result']['id'];
          //   final role = responseMyInfo['data']['result']['role'];
          //   final name = responseMyInfo['data']['result']['name'];
          //   final status = responseMyInfo['data']['result']['status'];
          //   final birthDay = responseMyInfo['data']['result']['birthDay'];
          //   final phone = responseMyInfo['data']['result']['phone'];
          //   final avt = responseMyInfo['data']['result']['avt'];
          //   // Save my info to storage
          //   await storageService.setString(StorageKeys.token, token);
          //   await storageService.setString(StorageKeys.userId, idAccount);
          //   await storageService.setString(StorageKeys.role, role);
          //   await storageService.setString(StorageKeys.name, name);
          //   await storageService.setString(StorageKeys.statusUser, status);
          //   await storageService.setString(StorageKeys.birthDay, birthDay);
          //   await storageService.setString(StorageKeys.phone, phone);
          //   await storageService.setString(StorageKeys.avt, avt);
          // }

        }
      } catch (e) {
        print("error: $e");
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

  Future<void> logout() async {
    final storageService = await StorageService.getInstance();
    await storageService.clear();
    Get.offNamed(RouteNames.login);
  }
}