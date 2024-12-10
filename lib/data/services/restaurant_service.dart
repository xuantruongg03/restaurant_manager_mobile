import 'dart:convert';

import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class RestaurantService {
  static Future<Map<String, dynamic>> createRestaurant(
      String name, String idAccount) async {
    try {
      final storageService = await StorageService.getInstance();
      final username = storageService.getString(StorageKeys.username);
      final password = storageService.getString(StorageKeys.password);

      final response = await ApiClient.post('/restaurant/create',
          headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$username:$password'))}'
      },
          body: {'name': name, 'idAccount': idAccount});

      return response;
    } catch (e) {
      return {'success': false, 'message': '$e', 'error': 'Lỗi hệ thống!'};
    }
  }
}
