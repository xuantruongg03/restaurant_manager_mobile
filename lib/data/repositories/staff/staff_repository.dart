import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/models/staff/staff_modal.dart';

class StaffRepository extends GetConnect {
  Future<List<StaffModal>> getStaff() async {
    final response = await ApiClient.get('/staff/get-all-staff');
    return response['data'].map<StaffModal>((staff) => StaffModal.fromJson(staff)).toList();
  }

  Future<StaffModal?> addStaff(StaffModal staff) async {
    final response = await ApiClient.post('/staff/add', body: staff.toJson());
    if (response['success'] == true) {
      return StaffModal.fromJson(response['data']);
    }
    return null;
  }

  Future<bool> deleteStaff(String staffId) async {
    final response = await ApiClient.delete('/staff/delete/$staffId');
    return response['success'] == true;
  }
}