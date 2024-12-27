import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/repositories/staff/add_staff_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/staff/add_staff_controller.dart';

class AddStaffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddStaffRepository());
    Get.lazyPut(() => AddStaffController(repository: Get.find<AddStaffRepository>()));
  }
}
