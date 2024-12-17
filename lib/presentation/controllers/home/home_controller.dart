import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/repositories/home/home_reponsitory.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class HomeController extends GetxController {
  final HomeRepository repository = HomeRepository();
  final List<Map<String, dynamic>> quickAccessItems = [
    {
      'title': 'Báo cáo',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.feature
    },
  ];

  void checkRestaurant() async {
    final storageService = await StorageService.getInstance();
    final nameRestaurant = storageService.getString(StorageKeys.restaurantName);
    if (nameRestaurant == '') {
      final idAccount = storageService.getString(StorageKeys.userId);
      if (idAccount == null) {
        Get.offNamedUntil(RouteNames.login, (route) => false);
        return;
      }
      const randomName = 'Nhà hàng 2';

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
    if (deviceToken == '' || deviceToken == null) {
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
