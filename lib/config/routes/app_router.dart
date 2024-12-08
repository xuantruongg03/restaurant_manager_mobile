import 'package:flutter/material.dart';
import '../../presentation/screens/auth/forgot_password.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/features/feature_screen.dart';
import '../../presentation/screens/foods/food_screen.dart';
import '../../presentation/screens/home/default_screen.dart';
import '../../presentation/screens/payment/bill_screen.dart';
import '../../presentation/screens/tables/table_screen.dart';
import '../../presentation/screens/auth/confirm_phone_screen.dart';
import '../../presentation/screens/auth/sign_up_screen.dart';
import '../../presentation/screens/auth/verify_screen.dart';
import '../../presentation/screens/foods/add_food_screen.dart';
import '../../presentation/screens/menu/add_menu.dart';
import '../../presentation/screens/menu/menu_screen.dart';
import '../../presentation/screens/orders/order_screen.dart';
import '../../presentation/screens/tables/add_table_screen.dart';
import '../../presentation/widgets/auth_wrapper.dart';
import 'route_names.dart';
class AppRouter {
  const AppRouter._();

  static final _routes = <String, WidgetBuilder>{
    RouteNames.login: (_) => const LoginScreen(),
    RouteNames.signUp: (_) => const SignUpScreen(),
    RouteNames.verify: (_) => const VerifyScreen(),
    RouteNames.forgotPassword: (_) => const ForgotPasswordScreen(),
    RouteNames.confirmPhone: (_) => const ConfirmPhoneScreen(),
    RouteNames.home: (_) => const AuthWrapper(child: DefaultScreen()),
    RouteNames.feature: (_) => const AuthWrapper(child: FeatureScreen()),
    RouteNames.orders: (_) => const AuthWrapper(child: OrderScreen()),
    RouteNames.menu: (_) => const AuthWrapper(child: MenuScreen()),
    RouteNames.addMenu: (_) => const AuthWrapper(child: AddMenuScreen()),
    RouteNames.food: (_) => const AuthWrapper(child: FoodScreen()),
    RouteNames.addFood: (_) => const AuthWrapper(child: AddFoodScreen()),
    RouteNames.tables: (_) => const AuthWrapper(child: TableScreen()),
    RouteNames.addTable: (_) => const AuthWrapper(child: AddTableScreen()),
    RouteNames.bill: (_) => const AuthWrapper(child: BillScreen()),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = _routes[settings.name];
    
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
}
