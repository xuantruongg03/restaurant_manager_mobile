import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/auth/user_modal.dart';
import 'package:restaurant_manager_mobile/data/repositories/auth/sign_up_repository.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';
import 'package:restaurant_manager_mobile/utils/functions.dart';

class SignUpController extends GetxController {
  final SignUpRepository _signUpRepository = SignUpRepository();
  final formKey = GlobalKey<FormState>();

  // Add controllers
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isTermsAccepted = false.obs;

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    if (!isTermsAccepted.value) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Bạn phải đồng ý với điều khoản và điều kiện'),
        ),
      );
      return;
    }
    isLoading.value = true;

    final user = UserModel(
      name: nameController.text,
      username: usernameController.text,
      phone: phoneController.text,
      password: passwordController.text,
    );

    try {
      final response = await signUp(user);
      if (response != null) {
        Functions.showSnackbar("Đăng ký thành công");
        Get.offAllNamed(RouteNames.login);
      } else {
        Functions.showSnackbar("Đăng ký thất bại. Vui lòng thử lại sau");
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Thêm các hàm validate
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên đăng nhập';
    }
    if (value.length < 5) {
      return 'Tên người dùng phải có ít nhất 5 ký tự';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên người dùng';
    }
    if (value.length < 5) {
      return 'Tên người dùng phải có ít nhất 5 ký tự';
    }
    return null;
  }

  // String? _validateEmail(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Vui lòng nhập email';
  //   }
  //   final emailRegex = RegExp(Regex.email);
  //   if (!emailRegex.hasMatch(value)) {
  //     return 'Email không đúng định dạng';
  //   }
  //   return null;
  // }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    final phoneRegex = RegExp(Regex.phone);
    if (!phoneRegex.hasMatch(value)) {
      return 'Số điện thoại không đúng định dạng';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất 1 chữ hoa';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất 1 chữ thường';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất 1 số';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt';
    }
    return null;
  }

  Future<dynamic> signUp(UserModel user) async {
    final response = await _signUpRepository.signUp(user);
    if (response != null) {
      return response;
    }
    return null;
  }
}