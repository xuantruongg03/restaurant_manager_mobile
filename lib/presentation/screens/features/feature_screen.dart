import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/utils/permission_utils.dart';

class FeatureScreen extends StatelessWidget {
  const FeatureScreen({super.key});

  Widget _buildFeatureItem({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 32, height: 32),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          const Header(title: "Chức năng"),

          // Grid of features
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                _buildFeatureItem(
                  icon: 'assets/icons/menu.png',
                  label: 'Menu',
                  color: Colors.green,
                  onTap: () => PermissionUtils.navigateIfHasPermission(
                    RouteNames.menu,
                    ['Owner', 'Manager'],
                  ),
                ),
                _buildFeatureItem(
                  icon: 'assets/icons/reservation.png',
                  label: 'Bàn',
                  color: Colors.brown,
                  onTap: () => PermissionUtils.navigateIfHasPermission(
                    RouteNames.tables,
                    ['Owner', 'Manager', 'Waiter'],
                  ),
                ),
                _buildFeatureItem(
                  icon: 'assets/icons/billing.png',
                  label: 'Thanh toán',
                  color: Colors.amber,
                  onTap: () => PermissionUtils.navigateIfOwner(RouteNames.payment),
                ),
                _buildFeatureItem(
                  icon: 'assets/icons/statistic.png',
                  label: 'Thống kê',
                  color: Colors.blue,
                  onTap: () => PermissionUtils.navigateIfOwner(RouteNames.statistic),
                ),
                _buildFeatureItem(
                  icon: 'assets/icons/person-group.png',
                  label: 'Nhân viên',
                  color: Colors.orange,
                  onTap: () => Get.toNamed(RouteNames.staff),
                ),
                // _buildFeatureItem(
                //   icon: 'assets/icons/sale.png',
                //   label: 'Chiến lược',
                //   color: Colors.red,
                //   onTap: () => Get.toNamed(RouteNames.strategy),
                // ),
                _buildFeatureItem(
                  icon: 'assets/icons/schedule.png',
                  label: 'Lịch làm việc',
                  color: Colors.indigo,
                  onTap: () => Get.toNamed(RouteNames.workSchedule),
                ),
                _buildFeatureItem(
                  icon: 'assets/icons/restaurant.png',
                  label: 'Nhà hàng',
                  color: Colors.purple,
                  onTap: () => PermissionUtils.navigateIfOwner(RouteNames.restaurant),
                ),
                _buildFeatureItem(
                  icon: 'assets/icons/report.png',
                  label: 'Báo cáo',
                  color: Colors.purple,
                  onTap: () => PermissionUtils.navigateIfOwner(RouteNames.report),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
