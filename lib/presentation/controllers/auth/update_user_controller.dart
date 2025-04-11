import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_manager_mobile/data/models/auth/userupdate_request.dart';
import 'package:restaurant_manager_mobile/data/repositories/auth/update_user_repository.dart';
import 'package:restaurant_manager_mobile/utils/functions.dart';

class UpdateUserController extends GetxController {
  final UpdateUserRepository repository;
  Rx<XFile?> selectedFile = Rx<XFile?>(null);
  UpdateUserController({required this.repository});
  var isLoading = false.obs;
  final imageUrl = "".obs;
  final birthdayController = TextEditingController();

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final imageUrl = await Functions.uploadImageToCloudinary(File(file.path));
      if (imageUrl != null) {
        this.imageUrl.value = imageUrl;
      }
      selectedFile.value = file;
    }
  }

  Future<void> updateUser({
    required String idAccount,
    String? name,
    DateTime? birthDate,
  }) async {
    if (name == null || name == "") {
      Functions.showSnackbar("Vui lòng nhập tên");
      return;
    }
    isLoading.value = true;

    try {
      final request = UserupdateRequest(
        idAccount: idAccount,
        name: name,
        avt: imageUrl.value,
        birthdate: birthDate,
      );

      final response = await repository.UpdateUser(request);
      if (response != null && response['success'] == true) {
        Functions.showSnackbar("Cập nhật thông tin thành công!");

        // Truyền dữ liệu đã cập nhật về màn hình trước đó
        Get.back(result: {
          'name': name,
          'avt': imageUrl.value,
          'birthDate': birthDate?.toIso8601String(),
        });
      } else {
        Functions.showSnackbar("Cập nhật thất bại: ${response?['message']}");
      }
    } catch (e) {
      Functions.showSnackbar("Đã xảy ra lỗi: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Future<String?> uploadImageToCloudinary(File imageFile) async {
  //   try {
  //     final String cloudName = dotenv.env['CLOUD_NAME'] ?? '';
  //     final String apiKey = dotenv.env['API_KEY'] ?? '';
  //     final String apiSecret = dotenv.env['API_SECRET'] ?? '';

  //     final uri =
  //         Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
  //     final request = http.MultipartRequest('POST', uri);

  //     request.fields['upload_preset'] = dotenv.env['UPLOAD_PRESET'] ?? '';
  //     request.fields['api_key'] = apiKey;
  //     request.fields['api_secret'] = apiSecret;
  //     request.files
  //         .add(await http.MultipartFile.fromPath('file', imageFile.path));

  //     final response = await request.send();
  //     if (response.statusCode == 200) {
  //       final responseData = await http.Response.fromStream(response);
  //       final data = jsonDecode(responseData.body);
  //       return data['secure_url'];
  //     } else {
  //       print('Failed to upload image: ${response.reasonPhrase}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //     return null;
  //   }
  // }

  @override
  void onClose() {
    birthdayController.dispose();
    super.onClose();
  }
}
