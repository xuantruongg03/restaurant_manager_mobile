import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          StylishBottomBar(
            option: BubbleBarOptions(
              barStyle: BubbleBarStyle.vertical,
              bubbleFillStyle: BubbleFillStyle.fill,
              opacity: 0.3,
            ),
            items: [
              BottomBarItem(
                icon: const Icon(PhosphorIconsBold.list),
                title: const Text('Chức năng'),
                selectedColor: AppColors.primary,
                unSelectedColor: Colors.grey,
              ),
              BottomBarItem(
                icon: const Icon(PhosphorIconsBold.receipt),
                title: const Text('Đơn hàng'),
                selectedColor: AppColors.primary,
                unSelectedColor: Colors.grey,
              ),
              // Center empty item for FAB
              BottomBarItem(
                icon: const Icon(PhosphorIconsBold.house),
                title: const Text('Trang chủ'),
                selectedColor: AppColors.primary,
                unSelectedColor: Colors.grey,
              ),
              BottomBarItem(
                icon: const Icon(PhosphorIconsBold.bell),
                title: const Text('Thông báo'),
                selectedColor: AppColors.primary,
                unSelectedColor: Colors.grey,
              ),
              BottomBarItem(
                icon: const Icon(PhosphorIconsBold.user),
                title: const Text('Cá nhân'),
                selectedColor: AppColors.primary,
                unSelectedColor: Colors.grey,
              ),
            ],
            currentIndex: selectedIndex,
            onTap: onItemTapped,
          ),
        ],
      ),
    );
  }

  // Widget _buildCenterButton(BuildContext context) {
  //   return Positioned(
  //     top: -30,
  //     left: 0,
  //     right: 0,
  //     child: GestureDetector(
  //       onTap: () => Navigator.pushNamed(context, RouteNames.home),
  //       child: Container(
  //         width: 60,
  //         height: 60,
  //         decoration: BoxDecoration(
  //           color: AppColors.primary,
  //           shape: BoxShape.circle,
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.2),
  //               spreadRadius: 2,
  //               blurRadius: 12,
  //               offset: const Offset(0, 4),
  //             ),
  //           ],
  //         ),
  //         child: const Icon(
  //           PhosphorIconsBold.house,
  //           color: Colors.white,
  //           size: 32,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
