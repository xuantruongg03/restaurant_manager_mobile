import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restaurant_manager_mobile/data/models/tables/table_modal.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/tables/merge_table_controller.dart';

class MergeModal extends GetView<MergeTableController> {
  final String? idTableMain;
  // Nếu có initialTable1, nó sẽ là main table
  bool get hasMainTable => idTableMain != null && idTableMain != '';

  const MergeModal({
    super.key,
    this.idTableMain
  });

  @override
  Widget build(BuildContext context) {
    controller.idTableMain.value = idTableMain ?? '';
    controller.getTables();
    print('idTableMain: ${idTableMain}');
    if(idTableMain != null && idTableMain != '') {
      controller.getMergeTables();
    } else {
      // controller.removeMergeTables();
    }

    Future<void> showTableSelectionModal(bool isFirstTable) async {
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
                      'Chọn bàn để gộp',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        controller.removeMergeTables();
                        Get.back();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Danh sách bàn có thể cuộn được
                SizedBox(
                  height: min(controller.listTables.length * 56.0, 300.0),
                  child: Obx(() => ListView.builder(
                        itemCount: controller.listTables.length,
                        itemBuilder: (context, index) {
                          final table = controller.listTables[index];
                          final tableNumber = table.name;
                          // Skip if this table is already selected as table1 or table2
                          if (table.idTable ==
                                  controller.table1.value.idTable ||
                              table.idTable ==
                                  controller.table2.value.idTable) {
                            return const SizedBox();
                          }
                          return ListTile(
                            leading: const Icon(Icons.table_restaurant),
                            title: Text(tableNumber),
                            onTap: () {
                              Get.back(result: table);
                            },
                          );
                        },
                      )),
                ),
              ],
            ),
          ),
        ),
      );

      if (result != null) {
        if (isFirstTable) {
          controller.setTables1(result);
        } else {
          controller.setTables2(result);
        }
      }
    }

    Widget buildSelectableTable({
      required bool isFirstTable,
      required Rx<TableModel>? selectedTable,
    }) {
      void handleCancelTable() {
        if (isFirstTable) {
          controller.setTables1(TableModel(
              idTable: '', name: '', status: '', time: '', isMerge: false, color: ''));
        } else {
          controller.setTables2(TableModel(
              idTable: '', name: '', status: '', time: '', isMerge: false, color: ''));
        }
      }

      return GestureDetector(
        onTap: () => showTableSelectionModal(isFirstTable),
        child: Column(
          children: [
            Stack(clipBehavior: Clip.none, children: [
              Obx(() {
                final isSelected = selectedTable != null && selectedTable.value.idTable.isNotEmpty;
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.orange : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.table_restaurant, size: 32),
                );
              }),
              Obx(() {
                if ((isFirstTable &&
                        controller.table1.value.idTable.isNotEmpty) ||
                    (!isFirstTable &&
                        controller.table2.value.idTable.isNotEmpty)) {
                  return Positioned(
                    top: -8,
                    right: -8,
                    child: GestureDetector(
                      onTap: handleCancelTable,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.cancel,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ]),
            const SizedBox(height: 8),
            Obx(() {
              final tableName = isFirstTable
                  ? controller.table1.value.name
                  : controller.table2.value.name;
              return Text(tableName.isNotEmpty ? tableName : 'Chọn bàn');
            }),
          ],
        ),
      );
    }

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
                    buildSelectableTable(
                            isFirstTable: true,
                            selectedTable: controller.table1,
                          ),
                    const SizedBox(width: 16),
                    Transform.rotate(
                      angle: 80 * 3.14159 / 180,
                      child: const Icon(PhosphorIconsBold.link, size: 24),
                    ),
                    const SizedBox(width: 16),
                    // Second table - luôn có thể chọn
                    buildSelectableTable(
                      isFirstTable: false,
                      selectedTable: controller.table2,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.canMergeTables() ? controller.mergeTables : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      'Gộp',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: controller.canSplitTable() ? controller.splitTable : null,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: Colors.orange, width: 1.5),
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
}
