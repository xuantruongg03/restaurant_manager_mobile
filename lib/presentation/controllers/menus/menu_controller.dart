import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/menus/menu_modal.dart';
import 'package:restaurant_manager_mobile/data/repositories/menus/menu_repository.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class MenusController extends GetxController {
  final MenuRepository repository;

  MenusController({required this.repository});

  final RxList<MenuModel> menuItems = <MenuModel>[].obs;
  final filterOptions = ['Tất cả', 'Hoạt động', 'Không hoạt động'].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxString error = ''.obs;
  final RxString selectedFilter = 'Tất cả'.obs;
  final RxBool sorted = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    try {
      isLoading.value = true;
      error.value = '';

      final items = await repository.getMenuItems();
      if (items == null) {
        return;
      }
      final storage = await StorageService.getInstance();
      for (var item in items) {
        if (item.isActive) {
          storage.setString(StorageKeys.idMenu, item.idMenu);
          break;
        }
      }
      menuItems.value = items;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateNameMenu(String idMenu, String nameMenu) async {
    isUpdating.value = true;
    final response = await repository.updateMenu(idMenu, nameMenu);
    if (response == null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Cập nhật tên menu thất bại')),
      );
      return;
    }
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(content: Text('Cập nhật tên menu thành công')),
    );
    fetchMenuItems();
    Get.back();
    isUpdating.value = false;
  }

  List<MenuModel> get filteredMenuItems {
    if (selectedFilter.value == 'Tất cả') return menuItems;
    return menuItems
        .where((item) => selectedFilter.value == 'Hoạt động'
            ? item.status == 'Active'
            : item.status == 'Inactive')
        .toList();
  }

  List<MenuModel> get sortedMenuItems {
    if (!sorted.value) return filteredMenuItems;
    final items = [...filteredMenuItems];
    items.sort((a, b) => a.name.compareTo(b.name));
    return items;
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  void toggleSort() {
    sorted.value = !sorted.value;
  }
}
