import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(
            title: 'Cấu hình thanh toán',
            showBackButton: true,
            showActionButton: true,
            
          ),
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
          ),
          const SizedBox(height: 16),
          _buildTextField(
            hint: 'Nhập secret key...',
            icon: Icons.key,
            isPassword: true,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            hint: 'Nhập access key...',
            icon: Icons.vpn_key,
            isPassword: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
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