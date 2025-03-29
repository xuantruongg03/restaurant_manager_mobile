import 'dart:convert';

import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/bills/bill_modal.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class BillRepository {
  get storageService => null;

  Future<List<BillModel>?> getBill(String idTable) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.offAllNamed(RouteNames.login);
        return null;
      }
      final storageService = await StorageService.getInstance();
      final response = await ApiClient.get('/food/get-by-id-table', headers: {
        'Authorization': 'Bearer ${storageService.getString(StorageKeys.token)}'
      }, queryParams: {
        'idTable': idTable,
      });
      print("response: ${response}");
      if (response['success'] == true) {
        final data = response['data']['data'];
        if (data is List) {
          return data.map((json) => BillModel.fromJson(json)).toList();
        } else {
          throw Exception(
              'Invalid data format: Expected List but got ${data.runtimeType}');
        }
      }
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>?> closeBill(String idBill) async {
    final auth = await AuthService().getAuth();
    if (auth == null) {
      Get.offAllNamed(RouteNames.login);
      return null;
    }
    final response = await ApiClient.get(
      '/bills/close-bill',
      headers: {
        'Authorization': 'Bearer ${storageService.getString(StorageKeys.token)}'
      },
      queryParams: {
        'idBill': idBill,
      },
    );
    if (response['success'] == true) {
      return response;
    }
    return null;
  }
}
