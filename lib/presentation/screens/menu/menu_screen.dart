import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/filter.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  static const filterOptions = ['Tất cả', 'Hoạt động', 'Không HĐ'];

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _selectedFilter = 'Tất cả';
  bool _sorted = false;

  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Menu 20k',
      'createdBy': 'Thoangtv',
      'createdAt': '21/08/2024',
      'color': Colors.orange,
      'isActive': true,
    },
    {
      'title': 'Menu 50k',
      'createdBy': 'Thoangtv',
      'createdAt': '21/08/2024',
      'color': Colors.purple,
      'isActive': false,
    },
    {
      'title': 'Menu 100k',
      'createdBy': 'Thoangtv',
      'createdAt': '21/08/2024',
      'color': Colors.blue,
      'isActive': false,
    },
  ];

  List<Map<String, dynamic>> get filteredMenuItems {
    if (_selectedFilter == 'Tất cả') return _menuItems;
    return _menuItems
        .where((item) => _selectedFilter == 'Hoạt động'
            ? item['isActive']
            : !item['isActive'])
        .toList();
  }

  List<Map<String, dynamic>> get sortedMenuItems {
    if (!_sorted) return filteredMenuItems;
    final items = List<Map<String, dynamic>>.from(filteredMenuItems);
    items.sort((a, b) => a['title'].compareTo(b['title']));
    return items;
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required String createdBy,
    required String createdAt,
    required Color color,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteNames.food);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 90,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'By: $createdBy',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Created at: $createdAt',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            if (isActive)
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/icons/icon-checked.png',
                  width: 24,
                  height: 24,
                ),
              ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with actions
          Header(
              title: "Menu",
              showActionButton: true,
              showBackButton: true,
              onActionPressed: () {
                Navigator.pushNamed(context, RouteNames.addMenu);
              }),

          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    '3 menu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Filter(
                        selectedValue: _selectedFilter,
                        options: MenuScreen.filterOptions,
                        sorted: _sorted,
                        onChanged: (value) {
                          setState(() {
                            _selectedFilter = value!;
                          });
                        },
                        onSorted: (value) {
                          setState(() {
                            _sorted = value;
                          });
                        },
                      ),
                    ]),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          // Menu list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: ListView(
                children: sortedMenuItems
                    .map((item) => _buildMenuItem(
                          context: context,
                          title: item['title'],
                          createdBy: item['createdBy'],
                          createdAt: item['createdAt'],
                          color: item['color'],
                          isActive: item['isActive'],
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
