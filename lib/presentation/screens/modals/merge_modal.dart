import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MergeModal extends StatefulWidget {
  final String? initialTable1;
  final String? initialTable2;

  // Nếu có initialTable1, nó sẽ là main table
  bool get hasMainTable => initialTable1 != null;

  const MergeModal({
    super.key,
    this.initialTable1,
    this.initialTable2,
  });

  @override
  State<MergeModal> createState() => _MergeModalState();
}

class _MergeModalState extends State<MergeModal> {
  String? selectedTable1;
  String? selectedTable2;

  @override
  void initState() {
    super.initState();
    selectedTable1 = widget.initialTable1;
    selectedTable2 = widget.initialTable2;
  }

  Future<void> _showTableSelectionModal(bool isFirstTable) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chọn bàn thứ hai',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Danh sách bàn có thể cuộn được
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: 10, // Số lượng bàn mẫu
                  itemBuilder: (context, index) {
                    final tableNumber = 'Bàn ${index + 1}';
                    return ListTile(
                      leading: const Icon(Icons.table_bar),
                      title: Text(tableNumber),
                      onTap: () {
                        Navigator.pop(context, tableNumber);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        if (isFirstTable) {
          selectedTable1 = result;
        } else {
          selectedTable2 = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.4),
      body: Center(
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Gộp bàn',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // First table
                    widget.hasMainTable
                        ? _buildMainTable()
                        : _buildSelectableTable(
                            isFirstTable: true,
                            selectedTable: selectedTable1,
                          ),
                    const SizedBox(width: 16),
                    Transform.rotate(
                      angle: 80 * 3.14159 / 180,
                      child: const Icon(PhosphorIconsBold.link, size: 24),
                    ),
                    const SizedBox(width: 16),
                    // Second table - luôn có thể chọn
                    _buildSelectableTable(
                      isFirstTable: false,
                      selectedTable: selectedTable2,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _canMergeTables() ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text(
                    'Gộp',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: Colors.orange),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Huỷ gộp',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Kiểm tra có thể gộp bàn không
  bool _canMergeTables() {
    if (widget.hasMainTable) {
      return selectedTable2 != null;
    }
    return selectedTable1 != null && selectedTable2 != null;
  }

  // Widget cho main table (không thể thay đổi)
  Widget _buildMainTable() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.orange,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.table_bar, size: 32, color: Colors.orange),
        ),
        const SizedBox(height: 8),
        Text(
          selectedTable1!,
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Widget cho bàn có thể chọn
  Widget _buildSelectableTable({
    required bool isFirstTable,
    required String? selectedTable,
  }) {
    return GestureDetector(
      onTap: () => _showTableSelectionModal(isFirstTable),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    selectedTable != null ? Colors.orange : Colors.grey[300]!,
                width: selectedTable != null ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.table_bar, size: 32),
          ),
          const SizedBox(height: 8),
          Text(selectedTable ?? 'Chọn bàn'),
        ],
      ),
    );
  }
}
