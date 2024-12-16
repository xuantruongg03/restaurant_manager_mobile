import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/home/home_controller.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/noti/noti_controller.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/orders/order_controller.dart';
import 'package:restaurant_manager_mobile/presentation/screens/features/feature_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/home/home_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/notifications/notifications_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/orders/order_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/profile/profile_screen.dart';

class MainLayoutController extends GetxController {
  OrderController orderController = OrderController();
  HomeController homeController = Get.put(HomeController());
  NotiController notiController = Get.put(NotiController());

  final List<Widget> screens = [
    const FeatureScreen(),
    const OrderScreen(),
    const HomeScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  var selectedIndex = 2.obs;

  void changeScreen(int index) {
    selectedIndex.value = index;
  }
}
