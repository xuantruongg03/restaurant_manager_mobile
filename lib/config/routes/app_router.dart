import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/presentation/screens/auth/forgot_password.dart';
import 'package:restaurant_manager_mobile/presentation/screens/auth/login_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/features/feature_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/home/home_screen.dart';
import '../../presentation/screens/auth/sign_up_screen.dart';
import '../../presentation/screens/auth/verify_screen.dart';
import 'route_names.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      //  case RouteNames.splash:
      //   return MaterialPageRoute(
      //     builder: (_) => const SplashScreen(),
      //   );

      case RouteNames.signUp:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );
      
      case RouteNames.home:
      return MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      );

      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      
      case RouteNames.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );

      case RouteNames.verify:
        return MaterialPageRoute(
          builder: (_) => const VerifyScreen(),
        );

      case RouteNames.feature:
        return MaterialPageRoute(
          builder: (_) => const FeatureScreen(),
        );
        
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}