import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/foods/add_food_controller.dart';

class AddFoodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddFoodController(addFoodRepository: Get.find()));
  }
}
