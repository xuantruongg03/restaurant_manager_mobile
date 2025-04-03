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
}
