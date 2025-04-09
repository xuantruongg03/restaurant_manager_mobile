import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/repositories/staff/work_schedule_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/staff/work_schedule_controller.dart';

class WorkSheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WorkScheduleRepository());
    Get.lazyPut(() =>
        WorkScheduleController(repository: Get.find<WorkScheduleRepository>()));
  }
}
