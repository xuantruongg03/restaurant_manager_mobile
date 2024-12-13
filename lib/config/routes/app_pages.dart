import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/middleware/auth_middleware.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/foods/add_food_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/menus/add_menu_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/foods/food_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/home/home_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/auth/login_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/menus/menu_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/table/table_binding.dart';
import 'package:restaurant_manager_mobile/presentation/layouts/main_layout.dart';
import 'package:restaurant_manager_mobile/presentation/screens/auth/login_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/foods/add_food_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/foods/food_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/home/home_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/menu/add_menu_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/menu/menu_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/tables/table_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: RouteNames.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),

//Protect route
    GetPage(
      name: RouteNames.splash,
      page: () => const MainLayout(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.menu,
      page: () => const MenuScreen(),
      binding: MenuBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.tables,
      page: () => const TableScreen(),
      binding: TablesBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.addMenu,
      page: () => const AddMenuScreen(),
      binding: AddMenuBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.food,
      page: () => const FoodScreen(),
      binding: FoodBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.addFood,
      page: () => AddFoodScreen(),
      binding: AddFoodBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
