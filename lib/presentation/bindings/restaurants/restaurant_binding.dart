import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/repositories/restaurants/restaurant_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/restaurants/restaurant_controller.dart';

class RestaurantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RestaurantRepository());
    Get.lazyPut(() => RestaurantController());
  }
}
