import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/restaurants/create_res_request.dart';
import 'package:restaurant_manager_mobile/data/repositories/home/home_reponsitory.dart';
import 'package:restaurant_manager_mobile/data/repositories/restaurants/restaurant_repository.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class HomeController extends GetxController {
  final HomeRepository repository = HomeRepository();
  final RestaurantRepository restaurantRepository = RestaurantRepository();
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

  Future<void> getRestaurant() async {
    final storageService = await StorageService.getInstance();
    String idAccount = "d19a3821-003f-4ec8-a136-9a32c8e07de0";
    final response = await restaurantRepository.getRestaurant();

    if (response != null && response['data']['result'] != null) {
      // final List<dynamic> restaurants = response['data']['result'];
      // for (var restaurant in restaurants) {
      //   final idRestaurant = restaurant['idRestaurant'];
      //   final nameRestaurant = restaurant['name'];
      //   final statusRestaurant = restaurant['status'];
      //   // Save info restaurant to storage
      //   await storageService.setString(StorageKeys.restaurantId, idRestaurant);
      //   await storageService.setString(StorageKeys.restaurantName, nameRestaurant);
      //   await storageService.setString(StorageKeys.restaurantStatus, statusRestaurant);
      // }
      final idRestaurant = response['data']['result']['idRestaurant'];
      final nameRestaurant = response['data']['result']['name'];
      final statusRestaurant = response['data']['result']['status'];
      // Save info restaurant to storage
      await storageService.setString(StorageKeys.restaurantId, idRestaurant);
      await storageService.setString(StorageKeys.restaurantName, nameRestaurant);
      await storageService.setString(StorageKeys.restaurantStatus, statusRestaurant);
    } else {
      // Create restaurant
      final createRestaurantRequest =
          CreateRestaurantRequest(name: "Nhà hàng 1", idAccount: idAccount);
      final responseCreateRestaurant =
          await restaurantRepository.createRestaurant(createRestaurantRequest);
      if (responseCreateRestaurant) {
        getRestaurant();
      }
    }
  }

  void registerDevicePushy() async {
    try {
      final storageService = await StorageService.getInstance();
      final deviceToken = storageService.getString(StorageKeys.deviceToken);

      if (deviceToken == null || deviceToken.isEmpty) {
        await repository.registerDevicePushy();
        storageService.getString(StorageKeys.deviceToken);
      }
    } catch (e) {
      print('Error in registerDevicePushy: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    getRestaurant();
    registerDevicePushy();
  }
}
