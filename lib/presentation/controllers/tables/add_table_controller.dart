import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/repositories/tables/add_table_repository.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/tables/table_controller.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

import '../../../data/models/tables/add_table_request.dart';

class AddTableController extends GetxController {
  final AddTableRepository _addTableRepository = AddTableRepository();

  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  Future<void> addTable() async {
    if (formKey.currentState!.validate()) {
      final store = await StorageService.getInstance();
      final restaurantId = store.getString(StorageKeys.restaurantId);
      if (restaurantId == null) {
        return;
      }
      final request = AddTableRequest(
          tableName: nameController.text, idRestaurant: restaurantId);
      print(nameController.text + 'and' + restaurantId);
      final response = await _addTableRepository.createTable(request);
      if (response != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Thêm mới thành công')),
        );
        Get.find<TablesController>().fetchTables();
        Get.back();
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Thêm mới thất bại')),
        );
      }
    }
  }
}
