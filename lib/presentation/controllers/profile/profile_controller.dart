import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/presentation/screens/auth/update_user_screen.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class ProfileController extends GetxController {
  final name = 'ádsadasd'.obs;
  final phone = ''.obs;
  final birthDate = ''.obs;
  final avt = ''.obs;
  final status = ''.obs;
  final role = ''.obs;
  final userId = ''.obs;
  final restaurantName = ''.obs;

  Future<void> getProfile() async {
    final storageService = await StorageService.getInstance();
    name.value = storageService.getString(StorageKeys.name) ?? '';
    phone.value = storageService.getString(StorageKeys.phone) ?? '';
    birthDate.value = storageService.getString(StorageKeys.birthDay) ?? '';
    avt.value = storageService.getString(StorageKeys.avt) ?? '';
    status.value = storageService.getString(StorageKeys.statusUser) ?? '';
    role.value = storageService.getString(StorageKeys.role) ?? '';
    userId.value = storageService.getString(StorageKeys.userId) ?? '';
    restaurantName.value =
        storageService.getString(StorageKeys.restaurantName) ?? '';
  }

  Future<void> navigateToUpdateUser() async {
    final result = await Get.to(() => UpdateUserScreen(
          idAccount: userId.value,
          name: name.value,
          birthDate: birthDate.value,
          avatar: avt.value,
        ));
    print("Result received in ProfileController: $result");

    if (result != null) {
      // Cập nhật thông tin hiển thị khi quay lại màn hình hồ sơ
      name.value = result['name'] ?? name.value;
      birthDate.value = result['birthDate'] ?? birthDate.value; // Ngày sinh
      avt.value = result['avt'] ?? avt.value; // Avatar

      // Cập nhật thông tin vào bộ nhớ (nếu cần)
      final storageService = await StorageService.getInstance();
      storageService.setString(StorageKeys.name, name.value);
      storageService.setString(StorageKeys.birthDay, birthDate.value);
      storageService.setString(StorageKeys.avt, avt.value);
    }
  }

  Future<void> logout() async {
    final storageService = await StorageService.getInstance();
    storageService.clear();
    Get.offAllNamed(RouteNames.login);
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }
}
