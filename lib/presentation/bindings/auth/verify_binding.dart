import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/auth/verify_controller.dart';

class VerifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VerifyController());
  }
}