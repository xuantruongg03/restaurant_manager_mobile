import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/auth/verify_controller.dart';

class VerifyScreen extends GetView<VerifyController> {
  const VerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Logo và tiêu đề
                const Center(
                  child: Column(
                    children: [
                      Text(
                        'EASTERY',
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'KaiseiDecol',
                        ),
                      ),
                      Text(
                        'The best your choise',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.orange,
                          fontFamily: 'KaiseiDecol',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Tiêu đề xác nhận
                const Text(
                  'Xác nhận tài khoản',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Đảm bảo an toàn cho bạn!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),

                // Verify image
                Center(
                  child: Image.asset(
                  'assets/images/verify-icon.png',
                  width: 100,
                  height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),

                // Input OTP
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 6,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.8,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                    6,
                    (index) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:Colors.grey[300]!,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: TextField(
                          controller: controller.controllers[index],
                          focusNode: controller.focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            errorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                          onSubmitted: (value) {
                            if (index < 5 && value.isNotEmpty) {
                              controller.focusNodes[index + 1].requestFocus();
                            }
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              if (index < 5) {
                                controller.focusNodes[index + 1].requestFocus();
                              } else {
                                FocusScope.of(context).unfocus();
                              }
                            } else if (value.isEmpty && index > 0) {
                              controller.focusNodes[index - 1].requestFocus();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Thời gian còn lại và nút gửi lại
                Obx(() => Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!controller.canResend.value) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Gửi lại sau ${controller.timerText}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ] else
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: controller.startTimer,
                          child: const Text(
                            'Gửi lại',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                )),
                const SizedBox(height: 20),

                // Nút sửa số điện thoại
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Colors.orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Sửa số điện thoại',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Nút xác nhận
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.handleVerify(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
