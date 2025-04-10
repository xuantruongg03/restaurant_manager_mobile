import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/orders/order_modal.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/accept_order.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/cancel_order.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/success_order.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../data/repositories/orders/order_repository.dart';

class OrderController extends GetxController {
  final OrderRepository orderRepository = OrderRepository();

  final RxList<OrderModal> orders = <OrderModal>[].obs;
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

  WebSocketChannel? channel;

  void connectWebSocket() async {
    final storageService = await StorageService.getInstance();
    final idRestaurant = storageService.getString(StorageKeys.restaurantId);
    final url = dotenv.env['WS_URL'] ?? 'ws://localhost:1234';

    channel = WebSocketChannel.connect(Uri.parse('$url?id=$idRestaurant'));

    channel!.stream.listen((message) {
      try {
        if (message != null) {
          fetchOrders();
        }
      } catch (e) {
        print("Error decoding message: $e"); // Log the error
      }
    }, onError: (error) {
      error.value = error.toString();
    }, onDone: () {
      channel!.sink.close();
    });
  }

  void disconnectWebSocket() {
    channel?.sink.close(); // Đóng kết nối WebSocket
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

  Future<void> updateOrderReceivedStatus(String idOrder) async {
    final response = await orderRepository.updateOrderReceivedStatus(idOrder);
    if (response != null) {
      fetchOrders();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
            content: Text('Đã nhận đơn hàng')),
      );
    }
  }

  Future<void> updateOrderSuccessStatus(String idOrder) async {
    final response = await orderRepository.updateOrderSuccessStatus(idOrder);
    if (response != null) {
      fetchOrders();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
            content: Text('Hoàn thành đơn hàng thành công')),
      );
    }
  }

  Future<void> updateOrderCancelStatus(String idOrder) async {
    final response = await orderRepository.updateOrderCancelStatus(idOrder);
    if (response != null) {
      fetchOrders();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
            content: Text('Huỷ đơn hàng thành công')),
      );
    }
  }

  List<OrderModal> get filteredOrders {
    List<OrderModal> items = orders;
    if (selectedFilter.value != 'Tất cả') {
      items =
          items.where((item) => item.status == selectedFilter.value).toList();
    }
    if (searchText.value.isNotEmpty) {
      items = items
          .where((item) => item.nameFood.contains(searchText.value))
          .toList();
    }
    return items;
  }

  List<OrderModal> get sortedOrders {
    if (!sorted.value) return filteredOrders;
    final items = [...filteredOrders];
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
        onCancel: (idOrder) {
          updateOrderCancelStatus(idOrder);
        },
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
        onSuccess: (idOrder) {
          updateOrderSuccessStatus(idOrder);
        },
      ),
    );
  }
}
