import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/data/repositories/auth/login_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/auth/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginRepository());
    Get.put(LoginController(
      repository: LoginRepository(),
    ));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Text(
                'EASTERY',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'KaiseiDecol',
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'The best your choise',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontFamily: 'KaiseiDecol',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(controller.getGreeting()),
              const SizedBox(height: 24),
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.usernameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        hintText: 'Tên đăng nhập',
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
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        errorStyle: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          height: 0.8,
                        ),
                      ),
                      validator: controller.validateUsername,
                    ),
                    const SizedBox(height: 16),
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
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: Obx(() => ElevatedButton(
                      onPressed:
                          controller.isLoading.value ? null : controller.login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Đăng nhập',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.0,
                              ),
                            ),
                    )),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteNames.forgotPassword);
                },
                child: const Text(
                  "Bạn quên mật khẩu ư?",
                  style: TextStyle(
                    color: AppColors.link,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      'Hoặc',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: Image.asset('assets/images/google-icon.png',
                            height: 24),
                        label: const Text(
                          'Google',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: Image.asset('assets/images/facebook-icon.png',
                            height: 24),
                        label: const Text(
                          'Facebook',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Tạo tài khoản mới?',
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteNames.signUp);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text(
                        'Đăng ký',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
