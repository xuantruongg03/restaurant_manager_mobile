import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/staff/add_staff_request.dart';
import 'package:restaurant_manager_mobile/data/repositories/staff/add_staff_repository.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/staff/staff_controller.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';
import 'package:restaurant_manager_mobile/utils/formats.dart';

class AddStaffController extends GetxController {
  final AddStaffRepository repository;

  AddStaffController({required this.repository});

  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController salaryTypeController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController bankAccountController = TextEditingController();

  final selectedName = 'truong'.obs;
  final selectedPhone = '0123456789'.obs;
  final selectedPosition = 'Nhân viên phục vụ'.obs;
  final selectedSalaryType = 'Theo tháng'.obs;

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

  @override
  void onInit() {
    super.onInit();
    // Set default values
    nameController.text = selectedName.value;
    phoneController.text = selectedPhone.value;
    positionController.text = selectedPosition.value;
    salaryTypeController.text = selectedSalaryType.value;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    positionController.dispose();
    salaryTypeController.dispose();
    salaryController.dispose();
    bankAccountController.dispose();
    super.onClose();
  }

  Future<void> addStaff() async {
    if (formKey.currentState!.validate()) {
      try {
        final storageService = await StorageService.getInstance();
        String resId = storageService.getString(StorageKeys.restaurantId) ?? '';
        String bankNumber = bankAccountController.text.split(' - ')[0];
        String bankName = bankAccountController.text.split(' - ')[1];
        AddStaffRequest request = AddStaffRequest(
            username: convertFullNameToUsername(nameController.text),
            password: 'Nhanvien@24',
            name: nameController.text,
            phone: phoneController.text,
            role: 'Owner',
            idRestaurant: resId,
            salary: '0',
            type: 'month',
            bankNumber: bankNumber,
            bankName: bankName);
        repository.createStaff(request);
        Get.snackbar(
          'Thành công',
          'Thêm nhân viên thành công',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        clearForm();
        Get.back();
      } catch (e) {
        Get.snackbar('Lỗi', 'Đã có lỗi xảy ra khi thêm nhân viên');
      }
    }
  }

  void clearForm() {
    nameController.clear();
    phoneController.clear();
    salaryController.clear();
    bankAccountController.clear();
    selectedName.value = 'truong';
    selectedPhone.value = '0123456789';
    selectedPosition.value = 'Nhân viên phục vụ';
    selectedSalaryType.value = 'Theo tháng';
    nameController.text = selectedName.value;
    phoneController.text = selectedPhone.value;
    positionController.text = selectedPosition.value;
    salaryTypeController.text = selectedSalaryType.value;
  }
}
