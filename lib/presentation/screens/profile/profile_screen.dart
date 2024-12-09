import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Header(
              title: "Thông tin cá nhân",
              showSettingButton: true,
              onSettingPressed: () {}
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Avatar and name section
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/images/avatar_demo.png'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'TruongNe',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'lexuantruong09@gmail.com',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(100, 36),
                        ),
                        child: const Text('Chỉnh sửa'),
                      ),

                      // Profile information section
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Thông tin cá nhân',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildInfoItem('Email:', 'lexuantruong09@gmail.com', PhosphorIconsRegular.envelopeSimple),
                            _buildInfoItem('Số điện thoại:', '0981793202', PhosphorIconsRegular.phone),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Tài khoản',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildInfoItem('ID:', 'tGHHGDFVND', null, showCopy: true),
                            _buildInfoItem('Trạng thái:', 'Hoạt động', null),
                            _buildInfoItem('Ngày hết hạn:', '24/08/2025', null)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData? icon, {bool showCopy = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          icon != null ? Icon(icon, size: 20) : const SizedBox.shrink(),
          icon != null ? const SizedBox(width: 8) : const SizedBox.shrink(),
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          const Spacer(),
          Text(value),
          if (showCopy) 
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(Icons.copy, size: 20),
              ),
            ),
        ],
      ),
    );
  }
}
