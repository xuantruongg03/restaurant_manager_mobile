import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class ProfileController extends GetxController {

  final name = ''.obs;
  final phone = ''.obs;
  final birthDay = ''.obs;
  final avt = ''.obs;
  final status = ''.obs;
  final role = ''.obs;
  final userId = ''.obs;
  final restaurantName = ''.obs;

  Future<void> getProfile() async {
    final storageService = await StorageService.getInstance();
    name.value = storageService.getString(StorageKeys.name) ?? '';
    phone.value = storageService.getString(StorageKeys.phone) ?? '';
    birthDay.value = storageService.getString(StorageKeys.birthDay) ?? '';
    avt.value = storageService.getString(StorageKeys.avt) ?? '';
    status.value = storageService.getString(StorageKeys.statusUser) ?? '';
    role.value = storageService.getString(StorageKeys.role) ?? '';
    userId.value = storageService.getString(StorageKeys.userId) ?? '';
    restaurantName.value = storageService.getString(StorageKeys.restaurantName) ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }
}
