import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/data/models/tables/table_modal.dart';
import 'package:restaurant_manager_mobile/data/repositories/tables/table_repository.dart';
import 'package:restaurant_manager_mobile/utils/functions.dart';

class OrderStaffModal extends StatefulWidget {
  final String idFood;
  final String nameFood;
  final String idTable;
  final String nameTable;
  final num quantity;
  final Function(String, String, String, num) onOrder;

  const OrderStaffModal(
      {super.key,
      required this.idFood,
      required this.nameFood,
      this.idTable = '',
      this.nameTable = '',
      this.quantity = 1,
      required this.onOrder});

  @override
  State<OrderStaffModal> createState() => _OrderStaffModalState();
}

class _OrderStaffModalState extends State<OrderStaffModal> {
  String selectedTableId = '';
  String selectedTableName = '';
  List<TableModel>? _cachedTables;
  bool _isLoading = false;
  final TextEditingController _quantityController = TextEditingController();
  num currentQuantity = 1;

  @override
  void initState() {
    super.initState();
    selectedTableId = widget.idTable;
    selectedTableName = widget.nameTable;
    currentQuantity = widget.quantity;
    _quantityController.text = widget.quantity.toString();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.4),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Đặt món',
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(widget.nameFood),
                    const Spacer(),
                    const Icon(Icons.restaurant, color: Colors.grey),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _quantityController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.grey[100]!),
                                    ),
                                    hintText: 'Số lượng',
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.all(8),
                                  ),
                                  onChanged: (value) {
                                    currentQuantity = num.tryParse(value) ?? 0;
                                  },
                                ),
                              ),
                              const Icon(Icons.wine_bar, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => showTableSelectionModal(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(selectedTableName != ''
                                    ? selectedTableName
                                    : 'Chọn bàn'),
                                const Icon(Icons.table_restaurant,
                                    color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  order();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Đặt',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: Colors.orange, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  foregroundColor: Colors.orange,
                ),
                child: const Text('Huỷ'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showTableSelectionModal() async {
    // Sử dụng cache nếu đã có
    final tables = _cachedTables ?? await fetchTables();
    _cachedTables = tables; // Lưu vào cache

    if (!mounted) return;
    final result = await showDialog<TableModel>(
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
                    'Chọn bàn',
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
              if (_isLoading)
                const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: tables.length,
                    itemBuilder: (context, index) {
                      final table = tables[index];
                      final tableNumber = 'Bàn ${table.name}';
                      return ListTile(
                        leading: const Icon(Icons.table_restaurant),
                        title: Text(tableNumber),
                        onTap: () => Navigator.pop(context, table),
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
        selectedTableId = result.idTable;
        selectedTableName = result.name;
      });
    }
  }

  Future<List<TableModel>> fetchTables() async {
    setState(() => _isLoading = true);
    TablesRepository repository = TablesRepository();
    final tables = await repository.getTables();
    setState(() => _isLoading = false);
    return tables ?? [];
  }

  void order() {
    if (currentQuantity < 1) {
      Functions.showSnackbar('Số lượng phải lớn hơn 0');
      return;
    }
    if (selectedTableId == '') {
      Functions.showSnackbar('Bàn không được để trống');
      return;
    }
    widget.onOrder(
        widget.idFood, widget.nameFood, selectedTableId, currentQuantity);
  }
}
