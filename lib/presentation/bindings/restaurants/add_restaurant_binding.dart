import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/repositories/restaurants/restaurant_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/restaurants/add_menu_controller.dart';

class AddRestaurantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => RestaurantRepository());
    Get.lazyPut(() => AddRestaurantController(repository: Get.find()));
  }
}
