import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_manager_mobile/data/repositories/auth/update_user_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/auth/update_user_controller.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';

class UpdateUserScreen extends StatelessWidget {
  final String idAccount;
  final String? name;
  final String? birthDate;
  final String? avatar;
   

  UpdateUserScreen({
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

  final ImagePicker _picker = ImagePicker();
  XFile? selectedFile;

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
              onPressedIcon: () {
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.pickImage();
                    },
                    child: const Text("Chọn ảnh đại diện"),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    return Center(
                      child: Text(
                        controller.selectedFile.value != null
                            ? "Đã chọn: ${controller.selectedFile.value!.name}"
                            : "Chưa chọn",
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Họ tên"),
                  ),
                  const SizedBox(height: 16),
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
                              // Validate dữ liệu và gửi yêu cầu cập nhật
                              controller.updateUser(
                                idAccount: idAccount,
                                name: nameController.text,
                                avt: selectedFile?.name ?? avatar,
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
