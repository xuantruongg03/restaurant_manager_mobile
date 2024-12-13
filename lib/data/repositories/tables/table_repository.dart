import 'dart:convert';

import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/tables/table_modal.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class TablesRepository {
  final ApiClient apiClient;

  TablesRepository({required this.apiClient});

  Future<List<TableModel>?> getTables() async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null;
      }
      final storageService = await StorageService.getInstance();
      final response = await ApiClient.get('/table/get', headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${auth['username']}:${auth['password']}'))}'
      }, queryParams: {
        'idRestaurant': storageService.getString(StorageKeys.restaurantId),
      });
      if (response['success'] == true) {
        final data = response['data']['data'];
        if (data is List) {
          return data.map((json) => TableModel.fromJson(json)).toList();
        } else {
          throw Exception(
              'Invalid data format: Expected List but got ${data.runtimeType}');
        }
      }
      return null;
    } catch (e) {
      print('error: $e');
      throw Exception('Failed to fetch tables: $e');
    }
  }
}
