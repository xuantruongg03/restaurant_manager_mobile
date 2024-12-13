import 'package:get/get.dart';
import '../../controllers/tables/add_table_controller.dart';

class AddTableBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddTableController());
  }
}
