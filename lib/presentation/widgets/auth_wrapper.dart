import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/presentation/screens/auth/login_screen.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Có lỗi xảy ra!'),
            ),
          );
        }

        final isAuthenticated = snapshot.data ?? false;
        if (!isAuthenticated) {
          return const LoginScreen();
        }

        return child;
      },
    );
  }

  Future<bool> _checkAuth() async {
    try {
      final storage = await StorageService.getInstance();
      final isLoggedIn = storage.getBool(StorageKeys.isLogin) ?? false;
      final userStatus = storage.getString(StorageKeys.statusUser);
      
      if (!isLoggedIn) {
        return false;
      }
      
      if (userStatus == null) {
        return false;
      }
      
      if (userStatus == 'inactive') {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
