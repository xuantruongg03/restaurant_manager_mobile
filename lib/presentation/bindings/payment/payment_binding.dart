import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/repositories/payment/payment_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/payment/payment_controller.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentRepository());
    Get.lazyPut(() => PaymentController(repository: Get.find<PaymentRepository>()));
  }
}
