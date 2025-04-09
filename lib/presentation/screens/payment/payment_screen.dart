import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/payment/payment_controller.dart';

class PaymentScreen extends GetView<PaymentController> {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Obx(() => Header(
                title: 'Cấu hình thanh toán',
                showBackButton: true,
                showActionButton: true,
                actionButtonText: controller.mode.value == 'create' ? 'Tạo' : 'Cập nhật',
                onActionPressed: () {
                  if (controller.mode.value == 'create') {
                    controller.createPayment();
                  } else {
                    controller.updatePayment();
                  }
                },
              )),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWarningSection(),
                    const SizedBox(height: 32),
                    _buildPaymentForm(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '* Vui lòng đăng ký tài khoản doanh nghiệp với Momo và cung cấp các thông tin sau cho chúng tôi để hoàn tất cấu hình thanh toán.',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '* Thông tin mà bạn cung cấp hoàn toàn được chúng tôi bảo mật tuyệt đối.',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentForm() {
    return Form(
      child: Column(
        children: [
          _buildTextField(
            hint: 'Nhập partner code...',
            icon: Icons.business,
            controller: controller.partnercode,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            hint: 'Nhập secret key...',
            icon: Icons.key,
            controller: controller.secretkey,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            hint: 'Nhập access key...',
            icon: Icons.vpn_key,
            controller: controller.accesskey,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập thông tin';
        }
        return null;
      },
    );
  }
}