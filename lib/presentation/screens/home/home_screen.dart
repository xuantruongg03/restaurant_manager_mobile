import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/utils/formats.dart';
import 'package:restaurant_manager_mobile/presentation/layouts/main_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Map<String, dynamic>> quickAccessItems = [
    {
      'title': 'Báo cáo',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.feature
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with logo and avatar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          PhosphorIconsBold.textAlignLeft,
                          size: 24,
                        ),
                        const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Eastery',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontFamily: 'KaiseiDecol',
                              ),
                            )),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[300],
                          child: const Icon(Icons.person),
                        ),
                      ],
                    ),
                  ),

                  // Promotions section title
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ưu đãi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(PhosphorIconsBold.arrowRight),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Sliding banners
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: PageController(
                        viewportFraction: 0.92,
                        initialPage: 0,
                      ),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: _buildPromotionCard(
                            index == 0 ? 'Special Sale Now' : 'Super Sale',
                            index == 0 ? 499000 : 1090000,
                            index == 0
                                ? 'Ưu đãi khách hàng mới'
                                : 'Giảm giá gói 3 tháng',
                            index == 0
                                ? 'assets/images/promotes/promote_1.png'
                                : 'assets/images/promotes/promote_2.png',
                          ),
                        );
                      },
                    ),
                  ),

                  // Quick access section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Truy cập nhanh',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                MainLayout.mainScreenKey.currentState
                                    ?.changeScreen(0);
                              },
                              child: const Icon(PhosphorIconsBold.arrowRight),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: quickAccessItems.length,
                            itemBuilder: (context, index) {
                              final item = quickAccessItems[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: _buildQuickAccessCard(
                                  item['title'],
                                  item['icon'],
                                  item['route'],
                                  context,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard(
      String title, String icon, String route, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Image.asset(
                icon,
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionCard(
      String title, num price, String description, String image) {
    return Card(
      margin: const EdgeInsets.only(right: 16.0),
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              width: double.infinity,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0, top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formatMoneyWithCurrency(price),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
