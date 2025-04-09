import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/staff/add_staff_request.dart';
import 'package:restaurant_manager_mobile/data/models/staff/staff_modal.dart';
import 'package:restaurant_manager_mobile/data/models/staff/update_staff_request.dart';
import 'package:restaurant_manager_mobile/data/repositories/staff/add_staff_repository.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';
import 'package:restaurant_manager_mobile/utils/formats.dart';

class AddStaffController extends GetxController {
  final AddStaffRepository repository;

  AddStaffController({required this.repository});
  final staffController = Get.find<StaffController>();
  final isEdit = false.obs;

  StaffModel? staff;

  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController salaryTypeController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController bankNumberController = TextEditingController();

  final selectedName = ''.obs;
  final selectedPhone = ''.obs;
  final selectedPosition = 'Phục vụ'.obs;
  final RxDouble selectedSalary = 0.0.obs;
  final selectedSalaryType = 'FullTime'.obs;
  final selectedBankName = ''.obs;
  final selectedBankNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Nhận argument truyền vào
    staff = Get.arguments as StaffModel?;
    if (staff != null) {
      isEdit.value = true;
      setName(staff!.name);
      setPhone(staff!.phone);
      setPosition(staff!.role);
      setSalary(staff!.baseSalary);
      setSalaryType(staff!.type);
      setBankName(staff!.bank);
      setBankNumber(staff!.bankAccountNumber);
    } else {
      // Set default values
      nameController.text = selectedName.value;
      phoneController.text = selectedPhone.value;
      positionController.text = selectedPosition.value;
      salaryTypeController.text = selectedSalaryType.value;
    }
  }

  void setName(String? name) {
    if (name != null) {
      selectedName.value = name;
      nameController.text = name;
    }
  }

  void setPhone(String? phone) {
    if (phone != null) {
      selectedPhone.value = phone;
      phoneController.text = phone;
    }
  }

  void setPosition(String? position) {
    if (position != null) {
      selectedPosition.value = position;
      positionController.text = position;
    }
  }

  void setSalaryType(String? type) {
    if (type != null) {
      selectedSalaryType.value = type;
      salaryTypeController.text = type;
    }
  }

  void setSalary(double salary) {
    selectedSalary.value = salary;
    salaryController.text = salary.toInt().toString();
  }

  void setBankName(String bankName) {
    selectedBankName.value = bankName;
    bankNameController.text = bankName.toString();
  }

  void setBankNumber(String bankNumber) {
    selectedBankNumber.value = bankNumber;
    bankNumberController.text = bankNumber.toString();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    positionController.dispose();
    salaryTypeController.dispose();
    salaryController.dispose();
    bankNameController.dispose();
    bankNumberController.dispose();
    super.onClose();
  }

  Future<bool> addStaff() async {
    if (formKey.currentState!.validate()) {
      try {
        final storageService = await StorageService.getInstance();
        String resId = storageService.getString(StorageKeys.restaurantId) ??
            '917f554a-98f2-406f-8862-f07730a6b8f1';
        String role = StaffModel.getRoleEN(selectedPosition.value);

        AddStaffRequest request = AddStaffRequest(
            username: convertFullNameToUsername(nameController.text),
            password: 'Nhanvien@24',
            name: nameController.text,
            phone: phoneController.text,
            role: role,
            idRestaurant: resId,
            salary: salaryController.text,
            type: selectedSalaryType.value,
            bankNumber: bankNumberController.text,
            bankName: bankNameController.text);

        bool success = await repository.createStaff(request);

        if (success) {
          Get.snackbar(
            'Thành công',
            'Thêm nhân viên thành công',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.back();
          return true;
        } else {
          return false;
        }
      } catch (e) {
        Get.snackbar('Lỗi', 'Đã có lỗi xảy ra khi thêm nhân viên');
        return false;
      }
    }

    return false;
  }

  Future<bool> updateStaff(String userId) async {
    if (formKey.currentState!.validate()) {
      try {
        String role = StaffModel.getRoleEN(selectedPosition.value);
        UpdateStaffRequest request = UpdateStaffRequest(
            name: nameController.text,
            phone: phoneController.text,
            role: role,
            salary: salaryController.text,
            type: selectedSalaryType.value,
            bankNumber: bankNumberController.text,
            bankName: bankNameController.text);

        bool success = await repository.updateStaff(userId, request);

        if (success) {
          Get.snackbar(
            'Thành công',
            'Cập nhật nhân viên thành công',
            backgroundColor: const Color.fromARGB(255, 95, 201, 98),
            colorText: Colors.white,
          );
          Get.back();
          return true;
        } else {
          return false;
        }
      } catch (e) {
        Get.snackbar('Lỗi', 'Đã có lỗi xảy ra khi cập nhật nhân viên');
        return false;
      }
    }

    return false;
  }

  void clearForm() {
    nameController.clear();
    phoneController.clear();
    salaryController.clear();
    bankNameController.clear();
    bankNumberController.clear();
    selectedName.value = '';
    selectedPhone.value = '';
    selectedPosition.value = 'Nhân viên phục vụ';
    selectedSalaryType.value = 'Theo tháng';
    nameController.text = selectedName.value;
    phoneController.text = selectedPhone.value;
    positionController.text = selectedPosition.value;
    salaryTypeController.text = selectedSalaryType.value;
  }
}
