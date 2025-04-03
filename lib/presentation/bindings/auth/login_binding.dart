import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/repositories/restaurants/restaurant_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/auth/login_controller.dart';
import 'package:restaurant_manager_mobile/data/repositories/auth/login_repository.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient());
    Get.lazyPut<LoginRepository>(() => LoginRepository());
    Get.lazyPut<RestaurantRepository>(() => RestaurantRepository());
    Get.lazyPut<LoginController>(() => LoginController(
      repository: Get.find<LoginRepository>(),
    ));
  }
}
