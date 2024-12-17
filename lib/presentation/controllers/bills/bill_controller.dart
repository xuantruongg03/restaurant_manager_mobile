import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/bills/bill_modal.dart';
import 'package:restaurant_manager_mobile/data/repositories/bills/bill_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/tables/table_controller.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/yn_modal.dart';

class BillController extends GetxController {
  final billRepository = BillRepository();
  final billList = <BillModel>[].obs;
  final idTable = Get.arguments['idTable'];
  final nameTable = Get.arguments['nameTable'];
  final idBill = "".obs;
  final total = 0.0.obs;
  final loading = false.obs;
  final error = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchBills();
  }

  Future<void> fetchBills() async {
    try {
      loading.value = true;
      final bills = await billRepository.getBill(idTable);
      if (bills != null) {
        billList.value = bills;
        idBill.value = billList.first.idBill;
        total.value = billList.fold(0, (sum, bill) => sum + bill.total);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> closeBill() async {
    final result = await billRepository.closeBill(idBill.value);
    if (result != null) {
      Get.back();
      Get.find<TablesController>().fetchTables();
    }
  }

  void showConfirmDialog() {
    Get.dialog(
      YNModal(
        title: "Xác nhận thanh toán!",
        content: "Bạn có chắc chắn muốn thanh toán bàn này không?",
        yesText: "Thanh toán",
        noText: "Hủy",
        onYes: (bool value) {
          if (value) {
            closeBill();
          }
        },
      ),
    );
  }
}
