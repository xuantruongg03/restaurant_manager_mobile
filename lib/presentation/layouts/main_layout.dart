import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/presentation/screens/features/feature_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/home/home_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/orders/order_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/notifications/notifications.dart';
import 'package:restaurant_manager_mobile/presentation/screens/profile/profile_screen.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/bottom_bar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 2;
  
  // Danh sách các màn hình
  final List<Widget> _screens = [
    const FeatureScreen(),
    const OrderScreen(),
    const HomeScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFFF2F4F7),
          child: _screens[_selectedIndex],
        ),
      ),
      extendBody: true, 
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
