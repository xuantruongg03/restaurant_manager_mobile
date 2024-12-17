import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/auth/sign_up_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
  }
}