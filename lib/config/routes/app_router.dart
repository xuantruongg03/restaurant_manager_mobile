import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/presentation/screens/auth/forgot_password.dart';
import 'package:restaurant_manager_mobile/presentation/screens/auth/login_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/features/feature_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/foods/food_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/home/home_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/payment/bill_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/tables/table_screen.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';
import '../../presentation/screens/auth/sign_up_screen.dart';
import '../../presentation/screens/auth/verify_screen.dart';
import '../../presentation/screens/menu/menu_screen.dart';
import '../../presentation/screens/menu/add_menu.dart';
import '../../presentation/screens/foods/add_food_screen.dart';
import '../../presentation/screens/tables/add_table_screen.dart';
import '../../presentation/screens/auth/confirm_phone_screen.dart';
import 'route_names.dart';

class AppRouter {
  const AppRouter._();

  static final _authRoutes = <String, WidgetBuilder>{
    RouteNames.login: (_) => const LoginScreen(),
    RouteNames.signUp: (_) => const SignUpScreen(),
    RouteNames.verify: (_) => const VerifyScreen(),
    RouteNames.forgotPassword: (_) => const ForgotPasswordScreen(),
    RouteNames.confirmPhone: (_) => const ConfirmPhoneScreen(),
  };

  static final _mainRoutes = <String, WidgetBuilder>{
    RouteNames.home: (_) => const HomeScreen(),
    RouteNames.feature: (_) => const FeatureScreen(),
  };

  static final _menuRoutes = <String, WidgetBuilder>{
    RouteNames.menu: (_) => const MenuScreen(),
    RouteNames.addMenu: (_) => const AddMenuScreen(),
  };

  static final _foodRoutes = <String, WidgetBuilder>{
    RouteNames.food: (_) => const FoodScreen(),
    RouteNames.addFood: (_) => const AddFoodScreen(),
  };

  static final _tableRoutes = <String, WidgetBuilder>{
    RouteNames.tables: (_) => const TableScreen(),
    RouteNames.addTable: (_) => const AddTableScreen(),
  };

  static final _paymentRoutes = <String, WidgetBuilder>{
    RouteNames.bill: (_) => const BillScreen(),
  };

  static final _routes = <String, WidgetBuilder>{
    ..._authRoutes,
    ..._mainRoutes,
    ..._menuRoutes,
    ..._foodRoutes,
    ..._tableRoutes,
    ..._paymentRoutes,
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = _routes[settings.name];

    if (settings.name == RouteNames.home) {
      return MaterialPageRoute(
        builder: (_) => FutureBuilder<Map<String, dynamic>>(
          future: _checkAuthAndStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const LoginScreen();
            }

            final data = snapshot.data!;
            final isLoggedIn = data['isLoggedIn'] as bool;
            final userStatus = data['status'] as String?;

            if (!isLoggedIn) {
              return const LoginScreen();
            }

            if (userStatus == 'inactive') {
              return const VerifyScreen();
            }

            return const HomeScreen();
          },
        ),
      );
    }

    if (builder != null) {
      return MaterialPageRoute(builder: builder);
    }

    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      ),
    );
  }

  static Future<Map<String, dynamic>> _checkAuthAndStatus() async {
    final storage = await StorageService.getInstance();
    final isLoggedIn = storage.getBool(StorageKeys.isLogin) ?? false;
    final userStatus = storage.getString(StorageKeys.statusUser);

    return {
      'isLoggedIn': isLoggedIn,
      'status': userStatus,
    };
  }
}
