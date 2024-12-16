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
      final response = await ApiClient.get('/bills/get-all-order', headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${auth['username']}:${auth['password']}'))}'
      }, queryParams: {
        'idRestaurant': storageService.getString(StorageKeys.restaurantId),
      });
      if (response['success'] == true) {
        final data = response['data']['data'];
        if (data is List) {
          final res = data[0];
          final foodDetails = res['foodDetails'];
          if (foodDetails is List) {
            final orders = foodDetails
                .map((food) => OrderModal.fromJson(food, res['nameTable']))
                .toList();
            return orders;
          } else {
            throw Exception(
                'Invalid format for foodDetails: Expected List but got ${foodDetails.runtimeType}');
          }
        } else {
          throw Exception(
              'Invalid data format: Expected List but got ${data.runtimeType}');
        }
      }

      throw Exception(response['message']);
    } catch (e) {
      print("error get orders: $e");
      throw Exception(e);
    }
  }
}
