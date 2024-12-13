import 'dart:convert';

import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/models/tables/add_table_request.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';

class AddTableRepository {
  Future<Map<String, dynamic>?> createTable(AddTableRequest request) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.offAllNamed('/login');
        return null;
      }
      final response = await ApiClient.post("/table/create",
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('${auth['username']}:${auth['password']}'))}'
          },
          body: request.toJson());
      if (response['success'] == true) {
        return response;
      }
      print('response: $response');
      return null;
    } catch (e) {
      print('error add table: $e');
      throw Exception('Failed to add table');
    }
  }
}
