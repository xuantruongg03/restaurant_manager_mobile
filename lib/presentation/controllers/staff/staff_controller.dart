import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/repositories/staff/staff_repository.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/yn_modal.dart';

class StaffController extends GetxController {
  final StaffRepository repository;

  StaffController({required this.repository});

  final RxList<Map<String, dynamic>> staffList = <Map<String, dynamic>>[].obs;
  final TextEditingController searchController = TextEditingController();
  final search = ''.obs;

  final RxBool isSelectAll = false.obs;
  final RxBool isSalaryAscending = true.obs;
  final RxBool isNameyAscending = true.obs;
  final RxBool isPositionAscending = true.obs;
  final RxString filteredRole = "Tất cả".obs;

  @override
  void onInit() {
    super.onInit();
    _loadFakeData();
  }

  // Fake data for staff list
  void _loadFakeData() {
    staffList.addAll([
      {
        'id': '1',
        'name': 'Nguyễn A',
        'phone': '0987654321',
        'position': 'Quản lý',
        'salary': 15000000,
        'salaryType': 'VNĐ',
        'startDate': '24/08/2024',
        'bankAccount': '1019940324 - VCB',
        'workHours': '8 Giờ',
        'hourlyWage': '14,000 VNĐ/ Giờ',
        'isExpanded': false.obs,
        'isChecked': false.obs,
      },
      {
        'id': '2',
        'name': 'Trần Thị B',
        'phone': '0971234567',
        'position': 'Thu ngân',
        'salary': 8000000,
        'salaryType': 'VNĐ',
        'bankAccount': '1019940324 - VCB',
        'startDate': '24/08/2024',
        'workHours': '8 Giờ',
        'hourlyWage': '14,000 VNĐ/ Giờ',
        'isExpanded': false.obs,
        'isChecked': false.obs,
      },
      {
        'id': '3',
        'name': 'Lê Văn C',
        'phone': '0909876543',
        'position': 'Bếp trưởng',
        'salary': 12000000,
        'salaryType': 'VNĐ',
        'startDate': '24/08/2024',
        'bankAccount': '1019940324 - VCB',
        'workHours': '8 Giờ',
        'hourlyWage': '14,000 VNĐ/ Giờ',
        'isExpanded': false.obs,
        'isChecked': false.obs,
      },
    ]);
  }

  // Function to add new staff
  void addNewStaff({
    required String name,
    required String phone,
    required String position,
    required String salary,
    required String salaryType,
    required String bankAccount,
  }) {
    staffList.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(), // Tạo id giả
      'name': name,
      'phone': phone,
      'position': position,
      'salary': salary,
      'salaryType': salaryType,
      'bankAccount': bankAccount,
    });
  }

  // Function to remove staff from staff list
  void removeStaff() {
    dynamic ids = getIdsSelected();
    if (ids is List<String>) {
      staffList.removeWhere((staff) => ids.contains(staff['id']));
    }

    refreshCheckBoxAll();
  }

  // Function to filter staff base on value of search input
  List<Map<String, dynamic>> get filteredStaff {
    if (search.value.isEmpty) return staffList;
    return staffList.where((staff) {
      return staff['name']
              .toString()
              .toLowerCase()
              .contains(search.value.toLowerCase()) ||
          staff['phone']
              .toString()
              .toLowerCase()
              .contains(search.value.toLowerCase());
    }).toList();
  }

  // Function to get list ids are selected
  List<String> getIdsSelected() {
    return filteredStaff
        .where((staff) => staff['isChecked'].value)
        .map((staff) => staff['id'].toString())
        .toList();
  }

  // Function to toggle checkbox all
  void toggleCheckBoxAll() {
    isSelectAll.value = !isSelectAll.value;
    for (var staff in filteredStaff) {
      staff['isChecked'].value = isSelectAll.value;
    }
  }

  // Check if all checkboxs is selected
  void refreshCheckBoxAll() {
    isSelectAll.value =
        filteredStaff.every((staff) => staff['isChecked'].value);
  }

  // Refresh all checkbox
  void refreshAllCheckBox() {
    isSelectAll.value = false;
    for (var staff in filteredStaff) {
      staff['isChecked'].value = false;
    }
  }

  // Check if at least 1 checkbox is selected
  bool hasSelected() {
    return filteredStaff.any((staff) => staff['isChecked'].value);
  }

  // Function to sort staff list base on key (salary, name, position)
  void sortBy(String key, RxBool isAscending) {
    isAscending.value = !isAscending.value;

    filteredStaff.sort((a, b) {
      dynamic valueA = a[key];
      dynamic valueB = b[key];

      if (key == 'name') {
        valueA = valueA.toString().split(' ').last;
        valueB = valueB.toString().split(' ').last;
      } else if (key == 'salary') {
        valueA =
            (valueA is int) ? valueA : int.tryParse(valueA.toString()) ?? 0;
        valueB =
            (valueB is int) ? valueB : int.tryParse(valueB.toString()) ?? 0;
      }

      return isAscending.value
          ? valueA.compareTo(valueB)
          : valueB.compareTo(valueA);
    });
  }

  // Function to show delete confirm dialog
  void showDeleteConfirmDialog() {
    Get.dialog(
      YNModal(
        title: "Xác nhận xóa!",
        content: "Bạn có chắc chắn muốn xóa nhân viên này không?",
        yesText: "Xóa",
        noText: "Hủy",
        onYes: (bool value) {
          if (value) {
            removeStaff();
          }
        },
      ),
    );
  }
}