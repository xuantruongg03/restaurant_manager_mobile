import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/filter.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/textfield_custom.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/accept_order.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/cancel_order.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/success_order.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Map<String, dynamic>> orders = [
    {
      'id': '1',
      'nameFood': 'Bánh mì',
      'quantity': 2,
      'nameTable': 'Bàn 1',
      'status': 'Đang chờ',
      'createdAt': '12/10/2024',
      'image': 'assets/images/image-food-demo.png',
    },
    {
      'id': '2',
      'nameFood': 'Bánh mì',
      'quantity': 2,
      'nameTable': 'Bàn 1',
      'status': 'Xác nhận',
      'createdAt': '12/10/2024',
      'image': 'assets/images/image-food-demo.png',
    },
  ];
  bool _sorted = false;
  String _selectedFilter = 'Tất cả';
  static const filterOptions = [
    'Tất cả',
    'Đang chờ',
    'Xác nhận',
  ];

  List<Map<String, dynamic>> get filteredOrders {
    var items = List<Map<String, dynamic>>.from(orders);
    if (_selectedFilter != 'Tất cả') {
      items = items.where((item) => item['status'] == _selectedFilter).toList();
    }
    return items;
  }

  List<Map<String, dynamic>> get sortedOrders {
    if (!_sorted) return filteredOrders;
    final items = List<Map<String, dynamic>>.from(filteredOrders);
    items.sort((a, b) => a['createdAt'].compareTo(b['createdAt']));
    return items;
  }

  void _showAcceptOrderModal(String orderId, String nameFood, num quantity,
      String nameTable) {
    showDialog(
      context: context,
      builder: (context) => AcceptOrderModal(
        orderId: orderId,
        nameFood: nameFood,
        quantity: quantity,
        nameTable: nameTable,
      ),
    );
  }

  void _showCancelOrderModal(String orderId, String nameFood, num quantity,
      String nameTable) {
    showDialog(
      context: context,
      builder: (context) => CancelOrderModal(
        orderId: orderId,
        nameFood: nameFood,
        quantity: quantity,
        nameTable: nameTable,
      ),
    );
  }

  void _showSuccessOrderModal(String orderId, String nameFood, num quantity,
      String nameTable) {
    showDialog(
      context: context,
      builder: (context) => SuccessOrderModal(
        orderId: orderId,
        nameFood: nameFood,
        quantity: quantity,
        nameTable: nameTable,
      ),
    );
  }

  Widget _buildOrderItem(String orderId, String nameFood, num quantity,
      String nameTable, String status, String createdAt, String image) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food image
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
              // Order details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nameFood,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Số lượng: $quantity',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Bàn: $nameTable',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Positioned icons at the bottom-right corner
          Positioned(
            bottom: 8,
            right: 0,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (status == 'Đang chờ') {
                      _showAcceptOrderModal(orderId, nameFood, quantity, nameTable);
                    } else if (status == 'Xác nhận') {
                      _showSuccessOrderModal(orderId, nameFood, quantity, nameTable);
                    }
                  },
                  child: Icon(Icons.edit_outlined,
                      size: 26, color: Colors.grey[600]),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    if (status == 'Đang chờ') {
                      _showCancelOrderModal(orderId, nameFood, quantity, nameTable);
                    }
                  },
                  child: Icon(status == 'Đang chờ' ? Icons.delete_outline : PhosphorIconsBold.bowlSteam,
                      size: 26, color: status == 'Đang chờ' ? Colors.grey[600] : AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const Header(title: "Đơn hàng"),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextFieldCustom(
              hintText: 'Tìm kiếm đơn hàng',
              prefixIcon: PhosphorIconsBold.magnifyingGlass,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${sortedOrders.length} đơn hàng',
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
              itemCount: sortedOrders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = sortedOrders[index];
                return _buildOrderItem(
                  order['id'],
                  order['nameFood'],
                  order['quantity'],
                  order['nameTable'],
                  order['status'],
                  order['createdAt'],
                  order['image'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
