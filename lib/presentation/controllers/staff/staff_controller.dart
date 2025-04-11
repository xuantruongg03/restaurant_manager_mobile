import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/staff/staff_modal.dart';
import 'package:restaurant_manager_mobile/data/repositories/staff/staff_repository.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/yn_modal.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class StaffController extends GetxController {
  final StaffRepository repository;

  StaffController({required this.repository});

  final RxString currentRole = ''.obs;
  final RxList<StaffModel> staffList = <StaffModel>[].obs;
  final RxList<StaffModel> filteredStaff = <StaffModel>[].obs;
  final TextEditingController searchController = TextEditingController();
  final search = ''.obs;

  final List<String> filterOptions = [
    'Tất cả',
    'Phục vụ',
    'Quản lý',
    'Bảo vệ',
    'Đầu bếp'
  ];
  final RxString filteredRole = "Tất cả".obs;
  final RxBool isSelectAll = false.obs;
  final RxBool isSalaryAscending = true.obs;
  final RxBool isNameAscending = true.obs;
  final RxBool isPositionAscending = true.obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStaffList();
  }

  @override
  void onReady() {
    super.onReady();
    print("Có quay lại");
    fetchStaffList();
    applyFilter();
  }

  // Gọi API để lấy danh sách nhân viên từ repository
  Future<void> fetchStaffList() async {
    try {
      final storageService = await StorageService.getInstance();
      currentRole.value =
          storageService.getString(StorageKeys.role) ?? 'Waiter';

      final result = await repository.getStaffList();

      if (result != null) {
        staffList.assignAll(result);
        applyFilter();
      }
    } catch (e) {
      errorMessage.value = 'Lỗi khi tải danh sách nhân viên: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Function to remove staff from staff list
  void removeStaff() {
    dynamic userIds = getUserIdsSelected();
    if (userIds is List<String>) {
      staffList.removeWhere((staff) => userIds.contains(staff.userId));

      if (staffList.length == 1) {
        repository.deleteStaff(userIds[0]);
      } else {
        repository.deleteMultiStaff(userIds);
      }

      applyFilter();
    }

    refreshCheckBoxAll();
    refreshAllCheckBox();
  }

  // Function to filter staff base on value of search input
  // List<StaffModel> get filteredStaff {
  //   if (search.value.isEmpty) return staffList;
  //   return staffList.where((staff) {
  //     return staff.name.toLowerCase().contains(search.value.toLowerCase());
  //   }).toList();
  // }
  void applyFilter() {
    List<StaffModel> tempList = staffList;

    if (filteredRole.value != "Tất cả") {
      tempList = tempList.where((s) => s.role == filteredRole.value).toList();
    }

    if (search.value.isNotEmpty) {
      tempList = tempList
          .where((staff) =>
              staff.name.toLowerCase().contains(search.value.toLowerCase()))
          .toList();
    }

    filteredStaff.assignAll(tempList);
  }

  // Function to get list ids are selected
  List<String> getUserIdsSelected() {
    return filteredStaff
        .where((staff) => staff.isSelected.value)
        .map((staff) => staff.userId.toString())
        .toList();
  }

  // Function to toggle checkbox all
  void toggleCheckBoxAll() {
    isSelectAll.value = !isSelectAll.value;
    for (StaffModel staff in filteredStaff) {
      staff.isSelected.value = isSelectAll.value;
    }
  }

  // Check if all checkboxs is selected
  void refreshCheckBoxAll() {
    isSelectAll.value = filteredStaff.every((staff) => staff.isSelected.value);
  }

  // Refresh all checkbox
  void refreshAllCheckBox() {
    isSelectAll.value = false;
    for (StaffModel staff in filteredStaff) {
      staff.isSelected.value = false;
    }
  }

  // Check if at least 1 checkbox is selected
  bool hasSelected() {
    return filteredStaff.any((staff) => staff.isSelected.value);
  }

  // Function to sort staff list base on key (salary, name, position)
  void sortBy(String key, RxBool isAscending) {
    isAscending.value = !isAscending.value;

    staffList.sort((a, b) {
      dynamic valueA;
      dynamic valueB;

      if (key == 'name') {
        valueA = _getVietnameseNameKey(a.name);
        valueB = _getVietnameseNameKey(b.name);
      } else if (key == 'salary') {
        valueA = a.baseSalary;
        valueB = b.baseSalary;
      } else if (key == 'role') {
        valueA = _getFirstWord(a.role);
        valueB = _getFirstWord(b.role);
      } else {
        valueA = a.role;
        valueB = b.role;
      }

      return isAscending.value
          ? valueA.compareTo(valueB)
          : valueB.compareTo(valueA);
    });

    applyFilter();
  }

// Lấy từ đầu tiên trong chuỗi
  String _getFirstWord(String text) {
    final parts = text.trim().toLowerCase().split(RegExp(r'\s+'));
    return parts.isNotEmpty ? parts.first : '';
  }

  String _getVietnameseNameKey(String fullName) {
    final parts = fullName.trim().toLowerCase().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0];
    return parts.last;
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
