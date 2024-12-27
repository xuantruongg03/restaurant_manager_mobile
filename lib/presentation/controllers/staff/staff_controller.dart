import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/repositories/staff/staff_repository.dart';


class StaffController extends GetxController {
  final StaffRepository repository;

  StaffController({required this.repository});

  final RxList<Map<String, dynamic>> staffList = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final search = ''.obs;

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

  List<Map<String, dynamic>> get filteredStaff {
    if (search.value.isEmpty) return staffList;
    return staffList.where((staff) {
      return staff['name'].toString().toLowerCase().contains(search.value.toLowerCase()) ||
             staff['phone'].toString().toLowerCase().contains(search.value.toLowerCase());
    }).toList();
  }

  void removeStaff(String id) {
    staffList.removeWhere((staff) => staff['id'] == id);
  }
}