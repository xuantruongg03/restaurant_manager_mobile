import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class AuthService {
  Future<Map?> getAuth() async {
    final storageService = await StorageService.getInstance();
    final token = storageService.getString(StorageKeys.token);

    if (token == null) {
      return null;
    }

    return {
      'token': token,
    };
  }

  Future<bool> checkAuth() async {
    final storageService = await StorageService.getInstance();
    final token = storageService.getString(StorageKeys.token);
    if(token != null) {
      final response = await ApiClient.post('/account/introspect', body: {
        'token': token
      }, headers: {
        'Authorization': 'Bearer $token'
      });
      print("introspect: ${response.toString()}");
      if(response['success'] == true) {
        return response['data']['result']['valid'];
      }
    }
    return false;
  }
}
