import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class AuthService {
  Future<Map?> getAuth() async {
    final storageService = await StorageService.getInstance();
    final username = storageService.getString(StorageKeys.username);
    final password = storageService.getString(StorageKeys.password);

    if (username == null || password == null) {
      return null;
    }

    return {
      'username': username,
      'password': password,
    };
  }
}
