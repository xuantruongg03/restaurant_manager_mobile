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
  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      selectedFile.value = file;
    }
  }
  Future<void> updateUser({
    required String idAccount,
    String? name,
    String? avt,
    DateTime? birthDate,
  }) async {
    isLoading.value = true; // Hiển thị trạng thái đang tải

    try {
      // Chuẩn bị request
      final request = UserupdateRequest(
        idAccount: idAccount,
        name: name,
        avt: avt,
        birthdate: birthDate,
      );

      // Gửi yêu cầu cập nhật
      final response = await repository.UpdateUser(request);

      // Xử lý phản hồi
      if (response != null && response['success'] == true) {
        Functions.showSnackbar("Cập nhật thông tin thành công!");
        Get.back(); // Quay lại màn hình trước đó
      } else {
        Functions.showSnackbar("Cập nhật thất bại: ${response?['message']}");
      }
    } catch (e) {
      Functions.showSnackbar("Đã xảy ra lỗi: $e");
    } finally {
      isLoading.value = false; // Ẩn trạng thái đang tải
    }
  }
}
