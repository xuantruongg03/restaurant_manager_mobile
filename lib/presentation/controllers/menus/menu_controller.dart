import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/menus/menu_modal.dart';
import 'package:restaurant_manager_mobile/data/repositories/menus/menu_repository.dart';

class MenusController extends GetxController {
  final MenuRepository repository;
  
  MenusController({required this.repository});

  final RxList<MenuModel> menuItems = <MenuModel>[].obs;
  final RxBool isLoading = false.obs;
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
      menuItems.value = items;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  List<MenuModel> get filteredMenuItems {
    if (selectedFilter.value == 'Tất cả') return menuItems;
    return menuItems.where((item) => 
      selectedFilter.value == 'Hoạt động' ? item.status == 'active' : item.status == 'inactive'
    ).toList();
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