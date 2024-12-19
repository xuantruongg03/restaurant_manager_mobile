import 'dart:convert';

import 'package:get/get.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class HomeRepository {
  Future<Map<String, dynamic>?> createRestaurant(String name, String idAccount) async {
    final auth = await AuthService().getAuth();
    if (auth == null) {
      Get.offAllNamed(RouteNames.login);
      return null;
    }
    final response = await ApiClient.post('/restaurant/create', headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode('${auth['username']}:${auth['password']}'))}'
    }, body: {
      'name': name,
      'idAccount': idAccount,
    });
    return response;
  }

  Future<void> registerDevicePushy() async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.offAllNamed(RouteNames.login);
        return;
      }

      String deviceToken = await Pushy.register();
      if (deviceToken.isEmpty) {
        return;
      }

      final storageService = await StorageService.getInstance();
      await storageService.setString(StorageKeys.deviceToken, deviceToken);
      
      storageService.getString(StorageKeys.deviceToken);

      // register device token to server
      final response = await ApiClient.post('/account/update-device-token', headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('${auth['username']}:${auth['password']}'))}'
      }, body: {
        'deviceToken': deviceToken,
        });
      if (response['success'] == true) {
        print('Register device pushy success');
      } else {
        print('Register device pushy failed');
      }
    } catch (e) {
      print('Error register device pushy: $e');
      throw Exception(e);
    }
  }
}
