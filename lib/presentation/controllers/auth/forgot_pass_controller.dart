import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final isLoading = false.obs;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> handleForgotPassword() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
    }
  }
}
