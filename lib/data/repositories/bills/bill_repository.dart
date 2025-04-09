import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/bills/bill_modal.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class BillRepository {
  get storageService => null;

  Future<BillModel?> getBill(String idTable) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.offAllNamed(RouteNames.login);
        return null;
      }
      final response = await ApiClient.get('/bills/get-all-order-client/$idTable', headers: {
        'Authorization': 'Bearer ${auth['token']}'
        });
      if (response['success'] == true) {
        final data = response['data']['result'];
        try {
          BillModel bill = BillModel.fromJson(data);
          return bill;
        } catch (e) {
          return null;
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
