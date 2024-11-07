import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../config/routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Thêm delay để hiển thị splash screen (tùy chọn)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Kiểm tra trạng thái đăng nhập
    final isLoggedIn = await AuthService().isLoggedIn();

    // Điều hướng dựa trên trạng thái
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, RouteNames.home);
    } else {
      Navigator.pushReplacementNamed(context, RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
