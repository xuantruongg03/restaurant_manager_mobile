import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/repositories/staff/report_repository.dart';
import 'package:restaurant_manager_mobile/data/repositories/staff/staff_repository.dart';
import 'package:restaurant_manager_mobile/data/repositories/staff/work_schedule_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/staff/work_schedule_controller.dart';

class WorkSheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => StaffRepository(apiClient: Get.find<ApiClient>()));
    Get.lazyPut(() => WorkScheduleRepository());
    Get.lazyPut(() => ReportRepository());
    Get.lazyPut(() => WorkScheduleController(
        workScheduleRepository: Get.find<WorkScheduleRepository>(),
        staffRepository: Get.find<StaffRepository>(),
        reportRepository: Get.find<ReportRepository>()));
  }
}
