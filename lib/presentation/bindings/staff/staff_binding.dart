import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/repositories/staff/staff_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/staff/staff_controller.dart';

class StaffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => StaffRepository(apiClient: Get.find()));
    Get.lazyPut(() => StaffController(repository: Get.find()));
  }
}
