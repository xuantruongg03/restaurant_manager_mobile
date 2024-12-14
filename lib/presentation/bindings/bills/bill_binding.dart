import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/bills/bill_controller.dart';

class BillBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BillController());
  }
}
