import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/tables/table_modal.dart';
import 'package:restaurant_manager_mobile/data/repositories/tables/table_repository.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/merge_modal.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/qr_modal.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';
import 'package:restaurant_manager_mobile/utils/functions.dart';


class TablesController extends GetxController {
  final TablesRepository repository;

  TablesController({required this.repository});
  
  final categories = ['Tất cả', 'Đang hoạt động', 'Trống'].obs;
  final RxList<TableModel> tables = <TableModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString selectedFilter = 'Tất cả'.obs;
  final RxBool sorted = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTables();
  }

  Future<void> fetchTables() async {
    try {
      isLoading.value = true;
      error.value = '';
      final data = await repository.getTables();
      if (data != null) {
        tables.value = data;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  List<TableModel> get filteredTables {
    var items = List<TableModel>.from(tables);

    if (selectedFilter.value != 'Tất cả') {
      if (selectedFilter.value == 'Trống') {
        items = items.where((item) => item.status == 'Available').toList();
      } else {
        items = items.where((item) => item.status != 'Available').toList();
      }
    }

    return items;
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  void showQRModal(String tableName, String tableId) async {
    final storage = await StorageService.getInstance();
    final idMenu = storage.getString(StorageKeys.idMenu);
    if (idMenu == null) {
      Functions.showSnackbar("Vui lòng chọn menu trước khi tạo QR");
      return;
    }
    final idRestaurant = storage.getString(StorageKeys.restaurantId);
    if (idRestaurant == null) {
      Functions.showSnackbar("Vui lòng chọn nhà hàng trước khi tạo QR");
      return;
    }
    Get.dialog(
      QRModal(
        name: tableName,
        tableId: tableId,
        idMenu: idMenu,
        idRestaurant: idRestaurant,
        onPrint: () => Get.back(),
      ),
    );
  }

  void showMergeModal() {
    Get.dialog(const MergeModal());
  }

  void showMergeModalWithTables(String table1, String table2) {
    Get.dialog(
      MergeModal(
        initialTable1: table1,
        initialTable2: table2,
      ),
    );
  }

  String convertStatus(String status) {
    if (status == 'Available') {
      return 'Trống';
    }
    return 'Đang hoạt động';
  }
}
