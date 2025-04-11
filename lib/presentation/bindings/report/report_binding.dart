import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/repositories/report/report_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/report/report_contoller.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => ReportRepository());
    Get.lazyPut(
        () => ReportContoller(reportRepository: Get.find<ReportRepository>()));
  }
}
