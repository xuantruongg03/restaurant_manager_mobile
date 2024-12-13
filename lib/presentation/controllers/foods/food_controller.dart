import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/foods/food_modal.dart';
import 'package:restaurant_manager_mobile/data/repositories/foods/food_repository.dart';

class FoodController extends GetxController {
  final FoodRepository repository;

  FoodController({required this.repository});

  final RxList<FoodModel> foods = <FoodModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString selectedFilter = 'Tất cả'.obs;
  final RxBool sorted = false.obs;
  final idMenu = Get.arguments['idMenu'];

  final filterOptions = [
    'Tất cả',
    'Chiên',
    'Nướng',
    'Xào',
    'Hấp',
    'Trộn'
  ].obs;

  final categories = ['Tất cả', 'Đồ ăn', 'Đồ uống', 'Khác'].obs;

  final selectedIndex = 0.obs;
  final selectedCategory = 'Tất cả'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFoods(idMenu);
  }

  void fetchFoods(String idMenu) async {
    try {
      isLoading.value = true;
      error.value = '';
      final foods = await repository.getFoods(idMenu);
      if (foods == null) {
        return;
      }
      this.foods.value = foods;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> get filteredFoodItems {
    var items = List<Map<String, dynamic>>.from(foods);

    if (selectedCategory != 'Tất cả') {
      items =
          items.where((item) => item['category'] == selectedCategory).toList();
    }

    if (selectedFilter != 'Tất cả') {
      items = items.where((item) => item['type'] == selectedFilter).toList();
    }

    return items;
  }

  List<Map<String, dynamic>> get sortedFoodItems {
    if (!sorted.value) return filteredFoodItems;
    final items = List<Map<String, dynamic>>.from(filteredFoodItems);
    items.sort((a, b) => a['name'].compareTo(b['name']));
    return items;
  }
}
