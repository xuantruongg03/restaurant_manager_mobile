import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/orders/order_modal.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/accept_order.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/cancel_order.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/success_order.dart';
import '../../../data/repositories/orders/order_repository.dart';

class OrderController extends GetxController {
  final OrderRepository orderRepository = OrderRepository();

  final orders = <OrderModal>[].obs;
  final sorted = false.obs;
  final isLoading = false.obs;
  final error = ''.obs;
  final selectedFilter = 'Tất cả'.obs;
  final searchText = ''.obs;
  final filterOptions = [
    'Tất cả',
    'Đang chờ',
    'Xác nhận',   
  ].obs;

  List<OrderModal> get filteredOrders {
    var items = List<OrderModal>.from(orders);
    if (selectedFilter.value != 'Tất cả') {
      items = items.where((item) => item.status == selectedFilter.value).toList();
    }
    if (searchText.value.isNotEmpty) {
      items = items.where((item) => item.nameFood.contains(searchText.value)).toList();
    }
    return items;
  }

  List<OrderModal> get sortedOrders {
    if (!sorted.value) return filteredOrders;
    final items = List<OrderModal>.from(filteredOrders);
    items.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return items;
  }

  void showAcceptOrderModal(
      String orderId, String nameFood, num quantity, String nameTable) {
    Get.dialog(
      AcceptOrderModal(
        orderId: orderId,
        nameFood: nameFood,
        quantity: quantity,
        nameTable: nameTable,
      ),
    );
  }

  void showCancelOrderModal(
      String orderId, String nameFood, num quantity, String nameTable) {
    Get.dialog(
      CancelOrderModal(
        orderId: orderId,
        nameFood: nameFood,
        quantity: quantity,
        nameTable: nameTable,
      ),
    );
  }

  void showSuccessOrderModal(
      String orderId, String nameFood, num quantity, String nameTable) {
    Get.dialog(
      SuccessOrderModal(
        orderId: orderId,
        nameFood: nameFood,
        quantity: quantity,
        nameTable: nameTable,
      ),
    );
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final items = await orderRepository.getOrders();
      if (items == null) {
        return;
      }
      orders.value = items;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
