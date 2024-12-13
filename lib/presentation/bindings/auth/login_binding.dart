import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/auth/login_controller.dart';
import 'package:restaurant_manager_mobile/data/repositories/auth/login_repository.dart';
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => LoginRepository());
    Get.lazyPut(() => LoginController(repository: Get.find()));
  }
}
