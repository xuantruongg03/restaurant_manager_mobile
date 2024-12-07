import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/presentation/layouts/main_layout.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:marquee/marquee.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/qr_modal.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/merge_modal.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  final List<Map<String, dynamic>> _tables = [
    {
      'id': 1,
      'name': "Bàn 1",
      'status': 'Trống',
      'time': '9h10',
      'isMerge': false
    },
    {
      'id': 2,
      'name': "Bàn 2",
      'status': 'Lên món',
      'time': '9h10',
      'isMerge': true
    },
    {
      'id': 3,
      'name': "Bàn 3",
      'status': 'Thanh toán',
      'time': '9h10',
      'isMerge': false
    },
  ];

  final List<String> _categories = ['Tất cả', 'Đang hoạt động', 'Trống'];
  int _selectedIndex = 0;
  String _selectedCategory = 'Tất cả';

  List<Map<String, dynamic>> get filteredTables {
    var items = List<Map<String, dynamic>>.from(_tables);

    if (_selectedCategory != 'Tất cả') {
      if (_selectedCategory == 'Đang hoạt động') {
        items = items.where((item) => item['status'] != 'Trống').toList();
      } else {
        items = items.where((item) => item['status'] == _selectedCategory).toList();
      }
    }

    return items;
  }

  void _showQRModal(String tableName, String tableId) {
    showDialog(
      context: context,
      builder: (context) => QRModal(
        name: tableName,
        tableId: tableId,
        onDownload: () {
          Navigator.pop(context);
        },
        onPrint: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showMergeModal() {
    showDialog(
      context: context,
      builder: (context) => const MergeModal(),
    );
  }

  void _showMergeModalWithTables(String table1, String table2) {
    showDialog(
      context: context,
      builder: (context) => MergeModal(
        initialTable1: table1,
        initialTable2: table2,
      ),
    );
  }

  Widget _buildTableItem(
      {required String name,
      required String status,
      required String time,
      required bool isMerge}) {
    return GestureDetector(
      onLongPress: () => _showQRModal(name, ""),
      onTap: () => Navigator.pushNamed(context, RouteNames.bill),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tên: $name",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isMerge)
                  GestureDetector(
                    onTap: () => _showMergeModalWithTables("Bàn 1", "Bàn 2"),
                    child: Transform.rotate(
                      angle: 80 * 3.14159 / 180,
                      child: const Icon(
                        PhosphorIconsBold.link,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  )
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 20,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textSpan = TextSpan(
                    text: "Trạng thái: $status",
                    style: const TextStyle(fontSize: 14),
                  );
                  final textPainter = TextPainter(
                    text: textSpan,
                    textDirection: TextDirection.ltr,
                    maxLines: 1,
                  )..layout(maxWidth: double.infinity);

                  if (textPainter.width > constraints.maxWidth) {
                    return Marquee(
                      text: "Trạng thái: $status",
                      style: const TextStyle(fontSize: 14),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: 20.0,
                      velocity: 30.0,
                      pauseAfterRound: const Duration(seconds: 1),
                      accelerationDuration: const Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: const Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    );
                  } else {
                    return Text(
                      "Trạng thái: $status",
                      style: const TextStyle(fontSize: 14),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Giờ vào: $time",
                  style: const TextStyle(fontSize: 14),
                ),
                if (status == 'Thanh toán')
                  const Icon(Icons.attach_money,
                      color: AppColors.primary, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0, right: 10),
        child: FloatingActionButton(
          onPressed: () => _showMergeModal(),
          backgroundColor: Colors.white,
          elevation: 0,
          shape: CircleBorder(
            side: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
          child: Transform.rotate(
            angle: 80 * 3.14159 / 180, // Convert 200 degrees to radians
            child: const Icon(PhosphorIconsBold.link, color: Colors.black),
          ),
        ),
      ),
      body: MainLayout(
        child: Column(
          children: [
            Header(
              title: "Bàn",
              showBackButton: true,
              showActionButton: true,
              onActionPressed: () {
                Navigator.pushNamed(context, RouteNames.addTable);
              },
              actionButtonText: "Thêm bàn",
            ),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _categories[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: _selectedIndex == index
                                ? AppColors.primary
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
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
            Expanded(
              child: Container(
                color: Colors.grey[100],
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: filteredTables.length,
                  itemBuilder: (context, index) {
                    final table = filteredTables[index];
                    return _buildTableItem(
                        name: table['name'],
                        status: table['status'],
                        time: table['time'],
                        isMerge: table['isMerge']);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
