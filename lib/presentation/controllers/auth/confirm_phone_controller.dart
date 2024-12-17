import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/repositories/auth/confirm_phone_repository.dart';

class ConfirmPhoneController extends GetxController {
  final ConfirmPhoneRepository confirmPhoneRepository = ConfirmPhoneRepository();
  final phoneController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeStorage();
  }

  Future<void> initializeStorage() async {
    phoneController.text = "0981793201";
    // storage = await StorageService.getInstance();
    // setState(() {
    //   username = storage.getString('username');
    //   password = storage.getString('password'); 
    // });
    
    // if (username != null && password != null) {
    //   // Có thể gọi API để lấy số điện thoại từ server
    //   try {
    //     final response = await _authService.getPhone(username!, password!);
    //     if (response['success']) {
    //       setState(() {
    //         _phoneController.text = response['data']['phone'] ?? '';
    //       });
    //     }
    //   } catch (e) {
    //     debugPrint('Error getting phone: $e');
    //   }
    // }
  }

  Future<void> handleConfirmPhone() async {
    isLoading.value = true;
    final response = await confirmPhoneRepository.sendOTP(phoneController.text);
    if (response != null) {
      Get.toNamed(RouteNames.verify, arguments: {
        'phone': phoneController.text
      });
    }
    isLoading.value = false;
  }

    @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}