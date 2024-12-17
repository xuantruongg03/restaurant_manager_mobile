import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/auth/forgot_pass_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPasswordController());
  }
}