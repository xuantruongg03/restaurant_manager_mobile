import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/data/repositories/auth/update_user_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/auth/update_user_controller.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';

class UpdateUserScreen extends StatelessWidget {
  final String idAccount;

  UpdateUserScreen({required this.idAccount});

  final UpdateUserController controller = Get.put(
    UpdateUserController(repository: UpdateUserRepository()),
  );

  final TextEditingController nameController = TextEditingController();
  final TextEditingController avtController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button
            Header(
              title: "Cập nhật thông tin",
              showBackButton: true, // Show back button
              onPressedIcon: () {
                Navigator.pop(context); // Navigate back when pressed
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(
                      height: 16), // Tạo khoảng cách giữa các TextField
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Họ tên"),
                  ),
                  const SizedBox(
                      height: 16), // Tạo khoảng cách giữa các TextField
                  TextField(
                    controller: avtController,
                    decoration:
                        const InputDecoration(labelText: "Ảnh đại diện (URL)"),
                  ),
                  const SizedBox(
                      height: 16), // Tạo khoảng cách giữa các TextField
                  TextField(
                    controller: birthDateController,
                    decoration: const InputDecoration(
                        labelText: "Ngày sinh (YYYY-MM-DD)"),
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 24),
                  Obx(() {
                    return ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              controller.updateUser(
                                idAccount: idAccount,
                                name: nameController.text,
                                avt: avtController.text,
                                birthDate:
                                    DateTime.tryParse(birthDateController.text),
                              );
                            },
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Lưu"),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
