import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/auth/userupdate_request.dart';
import 'package:restaurant_manager_mobile/data/repositories/auth/update_user_repository.dart';
import 'package:restaurant_manager_mobile/utils/functions.dart';

class UpdateUserController extends GetxController {
  final UpdateUserRepository repository;

  UpdateUserController({required this.repository});
  var isLoading = false.obs;

  Future<void> updateUser({
    required String idAccount,
    String? name,
    String? avt,
    DateTime? birthDate,
  }) async {
    isLoading.value = true;

    try {
      final request = UserupdateRequest(
        idAccount: idAccount,
        name: name,
        avt: avt,
        birthdate: birthDate,
      );

      final response = await repository.UpdateUser(request);

      if (response != null && response['success'] == true) {
        Functions.showSnackbar("Cập nhật thành công!");
        Get.back(); // Quay lại màn hình trước đó
      } else {
        Functions.showSnackbar(
            "Cập nhật thất bại: ${response?['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      Functions.showSnackbar("Đã xảy ra lỗi: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {}
}
