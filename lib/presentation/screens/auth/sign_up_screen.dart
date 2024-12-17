import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/auth/sign_up_controller.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 40),
              // Logo and tagline
              const Center(
                child: Column(
                  children: [
                    Text(
                      'EASTERY',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 35,
                        // fontWeight: FontWeight.bold,
                        fontFamily: 'KaiseiDecol',
                      ),
                    ),
                    Text(
                      'The best your choise',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontFamily: 'KaiseiDecol',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Title
              const Text(
                'Tạo tài khoản mới',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Khởi đầu của sự thành công',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              // Form fields
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        prefixIcon: const Icon(Icons.person_outline),
                        hintText: 'Tên người dùng',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      validator: controller.validateName,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        prefixIcon: const Icon(PhosphorIconsRegular.userCircle),
                        hintText: 'Tên đăng nhập',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      validator: controller.validateUsername,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      controller: controller.phoneController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        prefixIcon: const Icon(Icons.phone_outlined),
                        hintText: 'Số điện thoại',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      validator: controller.validatePhone,
                    ),
                    const SizedBox(height: 12),
                    Obx(() => TextFormField(
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible.value,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                controller.isPasswordVisible.value =
                                    !controller.isPasswordVisible.value;
                              },
                            ),
                            hintText: 'Mật khẩu',
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          validator: controller.validatePassword,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Sign up button
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.register,
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Đăng ký'),
                    )),
              ),
              const SizedBox(height: 20),
              // Terms and conditions
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.isTermsAccepted.value =
                          !controller.isTermsAccepted.value;
                    },
                    child: Obx(() => Icon(
                          controller.isTermsAccepted.value
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 20,
                          color: AppColors.primary,
                        )),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text:
                                  'Bằng cách ấn "Đăng ký", bạn đã đồng ý với '),
                          TextSpan(
                            text: 'chính sách',
                            style: TextStyle(color: AppColors.primary),
                          ),
                          TextSpan(text: ' và '),
                          TextSpan(
                            text: 'điều kiện',
                            style: TextStyle(color: AppColors.primary),
                          ),
                          TextSpan(text: ' của chúng tôi'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Login link
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: AppColors.disableButton),
                    children: [
                      const TextSpan(text: 'Bạn đã có tài khoản? '),
                      TextSpan(
                        text: 'Đăng nhập',
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.offAllNamed(RouteNames.login);
                          },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
