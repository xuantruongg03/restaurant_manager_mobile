import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/repositories/home/home_reponsitory.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(repository: HomeRepository()));
  }
}
