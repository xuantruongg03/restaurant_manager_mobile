import 'dart:convert';

import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/bills/bill_modal.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';


class BillRepository {
  Future<BillModel?> getBill(String idTable) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.offAllNamed(RouteNames.login);
        return null;
      }
      final response = await ApiClient.get(
        '/bill/get',
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${auth['username']}:${auth['password']}'))}'
        },
        queryParams: {
          'idTable': idTable,
        }
      );
      if (response['success'] == true) {
        return BillModel.fromJson(response['data']);
      }
      throw Exception(response['message']);
    } catch (e) {
      throw Exception(e);
    }
  }
}
