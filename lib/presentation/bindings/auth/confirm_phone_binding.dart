import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/auth/confirm_phone_controller.dart';

class ConfirmPhoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConfirmPhoneController());
  }
}