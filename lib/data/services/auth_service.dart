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
      try {
        final response = await ApiClient.post('/account/introspect', body: {
        'token': token
      }, headers: {
        'Authorization': 'Bearer $token'
        });
        if (response['success'] == true) {
          return response['data']['result']['valid'];
        }
      } catch (e) {
        print("error: $e");
      }
    }
    return false;
  }
}
