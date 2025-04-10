import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:your_app/core/services/storage_service.dart';
import 'package:your_app/core/utils/storage_keys.dart';
import 'package:your_app/domain/repositories/menu_repository.dart';

class MenusController extends GetxController {
  final MenuRepository repository;

  MenusController(this.repository);

  Future<void> updateStatusMenu(String idMenu, String status) async {
    final storage = await StorageService.getInstance();
    final menuList = storage.getList(StorageKeys.menu);
    String nameMenu = "";
    
    // Convert the List<Object> to List<Map<String, dynamic>> safely
    final List<Map<String, dynamic>> menu = List<Map<String, dynamic>>.from(menuList as List);
    
    for (var item in menu) {
      if (item['idMenu'] == idMenu) {
        nameMenu = item['name'];
        item['isSelected'] = true;
      } else {
        item['isSelected'] = false;
      }
    }
    
    final response = await repository.updateMenu(idMenu, nameMenu, status);
    if (response == null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Cập nhật menu thất bại')),
      );
      return;
    }
    storage.setList(StorageKeys.menu, menu);
    fetchMenuItems();
  }
}