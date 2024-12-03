import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/presentation/layouts/main_layout.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/textfield_custom.dart';
import 'package:restaurant_manager_mobile/utils/formats.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/filter.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final List<Map<String, dynamic>> _foods = [
    {
      'name': 'Bún bò',
      'price': 180000,
      'image': 'assets/images/image-food-demo.png',
      'type': 'Chiên',
      'id': '1',
      'category': 'Đồ ăn',
    },
    {
      'name': 'Bún bò',
      'price': 180000,
      'image': 'assets/images/image-food-demo.png',
      'type': 'Nướng',
      'id': '2',
      'category': 'Đồ ăn',
    },
        {
      'name': 'Bún bò',
      'price': 180000,
      'image': 'assets/images/image-food-demo.png',
      'type': 'Nướng',
      'id': '2',
      'category': 'Đồ ăn',
    },
        {
      'name': 'Bún bò',
      'price': 180000,
      'image': 'assets/images/image-food-demo.png',
      'type': 'Nướng',
      'id': '2',
      'category': 'Đồ ăn',
    },
        {
      'name': 'Bún bò',
      'price': 180000,
      'image': 'assets/images/image-food-demo.png',
      'type': 'Nướng',
      'id': '2',
      'category': 'Đồ ăn',
    },
        {
      'name': 'Bún bò',
      'price': 180000,
      'image': 'assets/images/image-food-demo.png',
      'type': 'Nướng',
      'id': '2',
      'category': 'Đồ ăn',
    },
        {
      'name': 'Bún bò',
      'price': 180000,
      'image': 'assets/images/image-food-demo.png',
      'type': 'Nướng',
      'id': '2',
      'category': 'Đồ ăn',
    },
  ];

  String _selectedFilter = 'Tất cả';
  bool _sorted = false;
  static const filterOptions = ['Tất cả', 'Chiên', 'Nướng', 'Xào', 'Hấp', 'Trộn'];
  final List<String> _categories = ['Tất cả', 'Đồ ăn', 'Đồ uống', 'Khác'];
  int _selectedIndex = 0;
  String _selectedCategory = 'Tất cả';

  List<Map<String, dynamic>> get filteredFoodItems {
    var items = List<Map<String, dynamic>>.from(_foods);

    if (_selectedCategory != 'Tất cả') {
      items = items.where((item) => 
        item['category'] == _selectedCategory).toList();
    }
    
    if (_selectedFilter != 'Tất cả') {
      items = items.where((item) =>
        item['type'] == _selectedFilter).toList();
    }
    
    return items;
  }

  List<Map<String, dynamic>> get sortedFoodItems {
    if (!_sorted) return filteredFoodItems;
    final items = List<Map<String, dynamic>>.from(filteredFoodItems);
    items.sort((a, b) => a['name'].compareTo(b['name']));
    return items;
  }

  Widget _buildFoodItem({
    required BuildContext context,
    required String title,
    required num price,
    required String image,
    required String id,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          //Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          //Title and Price
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatMoneyWithCurrency(price),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
          //Action
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 25,
                width: 25,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    PhosphorIconsBold.plus,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(
                    PhosphorIconsBold.pencilSimpleLine,
                    color: AppColors.outline,
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Icon(
                    PhosphorIconsBold.trash,
                    color: AppColors.outline,
                    size: 20,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          Header(
              title: 'Thực đơn',
              showActionButton: true,
              showBackButton: true,
              onActionPressed: () {
                Navigator.pushNamed(context, RouteNames.addFood);
              }),
          Container(
            height: 50,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                _categories.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                      _selectedCategory = _categories[index];
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _categories[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _selectedIndex == index
                              ? AppColors.primary
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: 2,
                        width: 50,
                        color: _selectedIndex == index
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextFieldCustom(
              hintText: 'Tìm kiếm món ăn',
              prefixIcon: PhosphorIconsBold.magnifyingGlass,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${sortedFoodItems.length} món',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Filter(
                  selectedValue: _selectedFilter,
                  options: filterOptions,
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
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: sortedFoodItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final food = sortedFoodItems[index];
                return _buildFoodItem(
                  context: context,
                  title: food['name'],
                  price: food['price'],
                  image: food['image'],
                  id: food['id'] ?? '',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
