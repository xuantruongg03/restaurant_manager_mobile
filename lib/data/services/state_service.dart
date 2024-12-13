import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class StateService extends GetxService {
  final _isAuthenticated = false.obs;

  bool get isAuthenticated => _isAuthenticated.value;

  void setAuthenticated(bool value) {
    _isAuthenticated.value = value;
  }

  Future<bool> checkAuth() async {
    try {
      final storageService = await StorageService.getInstance();
      final isLogin = storageService.getBool(StorageKeys.isLogin);
      final userId = storageService.getString(StorageKeys.userId);
      _isAuthenticated.value = (isLogin ?? false) && userId != null;
      return _isAuthenticated.value;
    } catch (e) {
      _isAuthenticated.value = false;
      return false;
    }
  }
}
