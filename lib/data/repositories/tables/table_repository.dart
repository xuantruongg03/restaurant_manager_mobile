import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/tables/table_modal.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class TablesRepository {
  Future<List<TableModel>?> getTables() async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null;
      }
      final storageService = await StorageService.getInstance();
      final response = await ApiClient.get(
        '/table/get/${storageService.getString(StorageKeys.restaurantId)}',
        headers: {
          'Authorization':
              'Bearer ${storageService.getString(StorageKeys.token)}'
        },
      );
      if (response['success'] == true) {
        final data = response['data']['result'];
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

  Future<bool> mergeTable(String idTable1, String idTable2) async {
    final auth = await AuthService().getAuth();
    if (auth == null) {
      Get.toNamed(RouteNames.login);
      return false;
    }
    final storageService = await StorageService.getInstance();
    final response = await ApiClient.post(
      '/bills/merge-table',
      body: {
        'idTable1': idTable1,
        'idTable2': idTable2,
      },
      headers: {
        'Authorization':
            'Bearer ${storageService.getString(StorageKeys.token)}'
      },
    );
    if (response['success'] == true) {
      return true;
    }
    return false;
  }

  Future<bool> splitTable(String table) async {
    final auth = await AuthService().getAuth();
    if (auth == null) {
      Get.toNamed(RouteNames.login);
      return false;
    }
    final response = await ApiClient.post(
      '/bills/un-merge-table/$table',
      headers: {
        'Authorization':
            'Bearer ${auth['token']}'
      },
    );
    if (response['success'] == true) {
      return true;
    }
    return false;
  }
}
