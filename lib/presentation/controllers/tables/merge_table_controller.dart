import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/merge_table_data.dart';
import 'package:restaurant_manager_mobile/data/models/tables/table_modal.dart';
import 'package:restaurant_manager_mobile/data/repositories/tables/table_repository.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/tables/table_controller.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class MergeTableController extends GetxController {
  final Rx<TableModel> table1 = TableModel(
          idTable: '',
          name: '',
          status: '',
          time: '',
          isMerge: false,
          color: '')
      .obs;
  final Rx<TableModel> table2 = TableModel(
          idTable: '',
          name: '',
          status: '',
          time: '',
          isMerge: false,
          color: '')
      .obs;
  final RxList<TableModel> listTables = <TableModel>[].obs;
  final Rx<int> length = 0.obs;
  final TablesRepository repository = TablesRepository();
  final RxBool isLoading = false.obs;
  final RxString idTableMain = ''.obs;

  void setTable1(TableModel table) {
    table1.value = table;
  }

  void setTable2(TableModel table) {
    table2.value = table;
  }

  Future<void> getTables() async {
    final tables = await repository.getTables();
    if (tables != null) {
      final listMergeTables = await getMergeTablesFromStorage(idTableMain.value);
      if (listMergeTables != null) {
        listTables.value = RxList.from(tables.where((element) =>
            !(listMergeTables['table1'] == element.idTable ||
                listMergeTables['table2'] == element.idTable)));
      } else {
        
        listTables.value = RxList.from(tables);
      }
      length.value = listTables.length;
    }
  }

  void setTables1(TableModel table) {
    table1.value = table;
  }

  void setTables2(TableModel table) {
    table2.value = table;
  }

  bool canSplitTable() {
    if (idTableMain.value == '') {
      return false;
    }
    return table1.value.name != '' && table2.value.name != '';
  }

  bool canMergeTables() {
    if (idTableMain.value != '') {
      return false;
    }
    if (table1.value.name != '') {
      return table2.value.name != '';
    }
    return table1.value.name != '' && table2.value.name != '';
  }

  Future<void> mergeTables() async {
    isLoading.value = true;
    try {
      final rs = await repository.mergeTable(
          table1.value.idTable, table2.value.idTable);
      if (rs) {
        Get.back();
        Get.find<TablesController>().onInit();
        // Lưu danh sách các bàn gộp dạng json ví dụ [{"idTable1": "1", "idTable2": "2"}, {"idTable1": "3", "idTable2": "4"}]
        saveMergeTables(table1.value.idTable, table2.value.idTable);
        removeMergeTables();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> splitTable() async {
    final rs = await repository.splitTable(table1.value.idTable);
    if (rs) {
      Get.back();
      Get.find<TablesController>().onInit();
      removeMergeTablesFromStorage(table1.value.idTable);
    }
  }

  Future<void> getMergeTables() async {
    final mergeTables = await getMergeTablesFromStorage(idTableMain.value);
    if (mergeTables != null) {
      try {
        final table1Data = listTables.firstWhereOrNull(
            (element) => element.idTable == mergeTables['table1']);
        final table2Data = listTables.firstWhereOrNull(
            (element) => element.idTable == mergeTables['table2']);
        if (table1Data != null && table2Data != null) {
          setTables1(TableModel(
            idTable: table1Data.idTable,
            name: table1Data.name,
            status: table1Data.status,
            time: table1Data.time,
            isMerge: true,
            color: mergeTables['color'],
          ));
          setTables2(TableModel(
            idTable: table2Data.idTable,
            name: table2Data.name,
            status: table2Data.status,
            time: table2Data.time,
            isMerge: true,
            color: mergeTables['color'],
          ));
        } else {
          print('One or both tables not found in listTables');
        }
      } catch (e) {
        print('Error finding merged table: $e');
      }
    }
  }

  void removeMergeTables() {
    table1.value = TableModel(
        idTable: '', name: '', status: '', time: '', isMerge: false, color: '');
    table2.value = TableModel(
        idTable: '', name: '', status: '', time: '', isMerge: false, color: '');
  }

  Future<void> saveMergeTables(String table1, String table2) async {
    final randomColor = getRandomColor();

    final mergeTableData = MergeTableData(
      table1: table1,
      table2: table2,
      color: randomColor.toString(),
    );

    final storageService = await StorageService.getInstance();
    try {
      storageService.setList(StorageKeys.mergeTables, [mergeTableData]);
    } catch (e) {
      print('Error saving merge tables: $e');
    }
  }

  Future<void> removeMergeTablesFromStorage(String idTable) async {
    final storageService = await StorageService.getInstance();
    List<Object>? listMergeTables =
        storageService.getList(StorageKeys.mergeTables);
    if (listMergeTables != null) {
      listMergeTables.removeWhere((element) =>
          (element as Map<String, dynamic>)['table1'] == idTable ||
          (element)['table2'] == idTable);
      storageService.setList(StorageKeys.mergeTables, listMergeTables);
    }
  }

  Future<Map<String, dynamic>?> getMergeTablesFromStorage(String idTable) async {
    final storageService = await StorageService.getInstance();
    List<Object>? listMergeTables =
        storageService.getList(StorageKeys.mergeTables);
    if (listMergeTables != null) {
      listMergeTables = listMergeTables.where((element) =>
          (element as Map<String, dynamic>)['table1'] == idTable ||
          (element)['table2'] == idTable).toList();
      if (listMergeTables.isNotEmpty) {
        return listMergeTables.first as Map<String, dynamic>;
      }
    }
    return null; // Return null if no merge tables are found
  }

  Color getRandomColor() {
    final random = Random();
    return Color(0xFF000000 | 
      random.nextInt(256) << 16 | // Red
      random.nextInt(256) << 8 |  // Green 
      random.nextInt(256)         // Blue
    );
  }
}
