import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/menus/menu_modal.dart';
import 'package:restaurant_manager_mobile/data/repositories/menus/menu_repository.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';
import 'package:restaurant_manager_mobile/utils/permission_utils.dart';

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
      final menu = storage.getList(StorageKeys.menu);
      for (var item in items) {
        final List<Map<String, dynamic>> menuList =
            List<Map<String, dynamic>>.from(menu as List);
        for (var itemMenu in menuList) {
          if (itemMenu['idMenu'] == item.idMenu) {
            item.isSelected = itemMenu['isSelected'];
          }
        }
      }
      menuItems.value = items;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatusMenu(String idMenu, String status) async {
    if (!await PermissionUtils.checkOwnerPermissionWithModal()) {
      return;
    }
    final storage = await StorageService.getInstance();
    final menu = storage.getList(StorageKeys.menu);
    final List<Map<String, dynamic>> menuList =
        List<Map<String, dynamic>>.from(menu as List);
    for (var item in menuList) {
      if (item['idMenu'] == idMenu) {
        item['isSelected'] = true;
        storage.setString(StorageKeys.idMenu, idMenu);
      } else {
        item['isSelected'] = false;
      }
    }
    storage.setList(StorageKeys.menu, menuList);
    fetchMenuItems();
  }

  Future<void> updateNameMenu(
      String idMenu, String nameMenu, String status) async {
    isUpdating.value = true;
    final response = await repository.updateMenu(idMenu, nameMenu, status);
    if (response == null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Cập nhật menu thất bại')),
      );
      return;
    }
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(content: Text('Cập nhật menu thành công')),
    );
    fetchMenuItems();
    Get.back();
    isUpdating.value = false;
  }

  Future<void> selectedMenu(String idMenu) async {
    final storage = await StorageService.getInstance();
    storage.setString(StorageKeys.idMenu, idMenu);
    fetchMenuItems();
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
