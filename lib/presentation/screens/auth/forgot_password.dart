import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                'Quên mật khẩu?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Hãy để chúng tôi giúp bạn!',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              // Form fields
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.email),
                  hintText: 'Email',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(children: [
                Expanded(
                    child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "* ",
                        style: TextStyle(color: Colors.red),
                      ),
                      TextSpan(
                        text:
                            "Chúng tôi sẽ gửi cho bạn một tin nhắn để đặt lại mật khẩu mới của bạn. Vui lòng kiểm tra email.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )),
              ]),
              const SizedBox(height: 30),
              // Confirm button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              // Login link
              const Spacer(),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: AppColors.disableButton),
                    children: [
                      const TextSpan(text: 'Tạo tài khoản mới? '),
                      TextSpan(
                        text: 'Đăng ký',
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacementNamed(
                                context, RouteNames.signUp);
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
