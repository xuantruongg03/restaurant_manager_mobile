import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/repositories/home/home_reponsitory.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class HomeController extends GetxController {
  final HomeRepository repository = HomeRepository();

  void checkRestaurant() async {
    final storageService = await StorageService.getInstance();
    final hasRestaurant = storageService.hasKey(StorageKeys.restaurantId);
    final nameRestaurant = storageService.getString(StorageKeys.restaurantName);
    if (!hasRestaurant || nameRestaurant == null) {
      final idAccount = storageService.getString(StorageKeys.userId);
      if (idAccount == null) {
        Get.offNamedUntil(RouteNames.login, (route) => false);
        return;
      }
      const randomName = 'Nhà hàng 1';

      //call api to create restaurant and get restaurant id set to storage
      final response = await repository.createRestaurant(randomName, idAccount);
      if (response != null) {
        storageService.setString(
            StorageKeys.restaurantId, response['data']['data']['idRestaurant']);
        storageService.setString(StorageKeys.restaurantName, randomName);
      }
    }
  }

  void registerDevicePushy() async {
    final storageService = await StorageService.getInstance();
    final deviceToken = storageService.getString(StorageKeys.deviceToken);
    final hasKey = storageService.hasKey(StorageKeys.deviceToken);
    if (deviceToken == null || !hasKey) {
      await repository.registerDevicePushy();
    }
  }

  @override
  void onInit() {
    super.onInit();
    checkRestaurant();
    registerDevicePushy();
  }
}
