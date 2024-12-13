import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/tables/table_modal.dart';
import 'package:restaurant_manager_mobile/data/repositories/tables/table_repository.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/merge_modal.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/qr_modal.dart';


class TablesController extends GetxController {
  final TablesRepository repository;

  TablesController({required this.repository});
  
  final categories = ['Tất cả', 'Đang hoạt động', 'Trống'];
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
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  List<Map<String, dynamic>> get filteredTables {
    var items = List<Map<String, dynamic>>.from(tables);

    if (selectedFilter.value != 'Tất cả') {
      if (selectedFilter.value == 'Đang hoạt động') {
        items = items.where((item) => item['status'] != 'Trống').toList();
      } else {
        items = items.where((item) => item['status'] == selectedFilter.value).toList();
      }
    }

    return items;
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  void showQRModal(String tableName, String tableId) {
    Get.dialog(
      QRModal(
        name: tableName,
        tableId: tableId,
        onDownload: () => Get.back(),
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
}
