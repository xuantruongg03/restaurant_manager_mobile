import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/config/routes/app_router.dart';
import 'package:restaurant_manager_mobile/core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Manager',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      
      // Routing
      initialRoute: '/sign-up', // Tạm thời set làm màn hình khởi đầu
      // initialRoute: RouteNames.splash, // Đặt route ban đầu là splash
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}