import 'dart:convert';

import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';
import '../../models/orders/order_modal.dart';

class OrderRepository extends GetConnect {
  Future<List<OrderModal>?> getOrders() async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return [];
      }
      final storageService = await StorageService.getInstance();
      final idRestaurant = storageService.getString(StorageKeys.restaurantId);
      // print("idRestaurant: $idRestaurant");
      final response = await ApiClient.get('/bills/get-all-order/$idRestaurant', headers: {
        'Authorization':
            'Bearer ${storageService.getString(StorageKeys.token)}'
      });
      print("response: $response");
      if (response['success'] == true) {
        final data = response['data']['result'];
        if (data is List && data.isNotEmpty) {
          final res = data[0];
          var foods = res['foods'];
          if (foods is String) {
            try {
              foods = jsonDecode(foods);
            } catch (e) {
              print("Error parsing foods string: $e");
              throw Exception('Invalid foods data format');
            }
          }
          if (foods is List) {
            final orders = foods
                .map((food) => OrderModal.fromJson(food, res['nameTable']))
                .toList();
            return orders;
          } else {
            throw Exception(
                'Invalid format for foods: Expected List but got ${foods.runtimeType}');
          }
        } 
        return null;
      }
      return null;
    } catch (e) {
      print("error get orders: $e");
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>?> updateOrderReceivedStatus(String idOrder) async {
    final auth = await AuthService().getAuth();
    if (auth == null) {
      Get.toNamed(RouteNames.login);
      return null;
    }
    final response = await ApiClient.put('/bills/order-update-received/$idOrder', headers: {
      'Authorization':
          'Bearer ${auth['token']}'
    });
    print("response: $response");
    if (response['success'] == true) {
      return response;
    }
    return null;
  }

  Future<Map<String, dynamic>?> updateOrderSuccessStatus(String idOrder) async {
    final auth = await AuthService().getAuth();
    if (auth == null) {
      Get.toNamed(RouteNames.login);
      return null;
    }
    final response = await ApiClient.put('/bills/order-update-complete/$idOrder', headers: {
      'Authorization':
          'Bearer ${auth['token']}'
    });
    print("response: $response");
    if (response['success'] == true) {
      return response;
    }
    return null;
  }

  Future<Map<String, dynamic>?> updateOrderCancelStatus(String idOrder) async {
    final auth = await AuthService().getAuth();
    if (auth == null) {
      Get.toNamed(RouteNames.login);
      return null;
    }
    final response = await ApiClient.delete('/bills/order-cancel/$idOrder', headers: {
      'Authorization':
          'Bearer ${auth['token']}'
    });
    print("response: $response");
    if (response['success'] == true) {
      return response;
    }
    return null;  
  }
}
