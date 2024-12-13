import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/repositories/foods/food_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/foods/food_controller.dart';

class FoodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FoodController(repository: FoodRepository()));
  }
}