import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/data/repositories/auth/update_user_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/auth/update_user_controller.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'dart:io';

class UpdateUserScreen extends StatelessWidget {
  final String idAccount;
  final String? name;
  final String? birthDate;
  final String? avatar;

  UpdateUserScreen({
    super.key,
    required this.idAccount,
    this.name,
    this.birthDate,
    this.avatar,
  });

  final UpdateUserController controller = Get.put(
    UpdateUserController(repository: UpdateUserRepository()),
  );

  late final TextEditingController nameController =
      TextEditingController(text: name ?? '');
  late final TextEditingController birthDateController =
      TextEditingController(text: birthDate ?? '');

  XFile? selectedFile;

  ImageProvider _getImageProvider() {
    if (controller.selectedFile.value != null) {
      return FileImage(File(controller.selectedFile.value!.path));
    }

    if (avatar != null && avatar!.isNotEmpty) {
      if (avatar!.startsWith('http')) {
        return NetworkImage(avatar!);
      }
      return FileImage(File(avatar!));
    }

    return const AssetImage('assets/images/avatar_demo.png');
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.birthdayController.text.isEmpty
          ? DateTime.now()
          : DateTime.parse(controller.birthdayController.text),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('vi', 'VN'),
    );

    if (picked != null) {
      controller.birthdayController.text =
          picked.toIso8601String().split('T')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
              title: "Cập nhật thông tin",
              showBackButton: true,
              showActionButton: true,
              onActionPressed: () {
                controller.updateUser(
                  idAccount: idAccount,
                  name: nameController.text,
                  avt: selectedFile?.name ?? avatar,
                  birthDate: controller.birthdayController.text.isEmpty
                      ? null
                      : DateTime.tryParse(controller.birthdayController.text),
                );
              },
              actionButtonText: "Lưu",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Stack(
                      children: [
                        Obx(() {
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: _getImageProvider(),
                          );
                        }),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                                size: 16,
                              ),
                              onPressed: () {
                                controller.pickImage();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Họ tên"),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.birthdayController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Ngày sinh',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
