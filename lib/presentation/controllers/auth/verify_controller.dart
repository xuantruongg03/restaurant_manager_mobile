import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/repositories/auth/verify_repository.dart';
import 'package:restaurant_manager_mobile/utils/functions.dart';

class VerifyController extends GetxController {
  final VerifyRepository verifyRepository = VerifyRepository();
  Timer? timer;
  final remainingSeconds = 0.obs;
  final canResend = true.obs;
  final phone = Get.arguments['phone'];
  final List<TextEditingController> controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    timer?.cancel();
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    remainingSeconds.value = 120; // 2 phút
    canResend.value = false;
    
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  String get timerText {
    int minutes = remainingSeconds.value ~/ 60;
    int seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get otp {
    return controllers.map((controller) => controller.text).join();
  }

  void handleVerify() async {
    final response = await verifyRepository.verifyPhone(phone, otp);
    if (response != null) {
      Get.offAllNamed(RouteNames.home);
    } else {
      Functions.showSnackbar(response?['message'] ?? 'Lỗi hệ thống!');
    }
  }
}