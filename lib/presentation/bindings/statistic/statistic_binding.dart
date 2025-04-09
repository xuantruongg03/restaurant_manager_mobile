import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/statistic/statistic_controller.dart';

class StatisticBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatisticController>(() => StatisticController());
  }
}