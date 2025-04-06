import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/repositories/tables/table_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/tables/merge_table_controller.dart';

class MergeTableBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MergeTableController());
    Get.lazyPut(() => TablesRepository());
  }
}

