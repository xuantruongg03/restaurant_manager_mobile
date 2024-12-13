import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/repositories/menus/menu_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/menus/menu_controller.dart';

class MenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => MenuRepository(apiClient: Get.find()));
    Get.lazyPut(() => MenusController(repository: Get.find()));
  }
}