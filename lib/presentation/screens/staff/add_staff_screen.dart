import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/staff/add_staff_controller.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/accept_staff.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';

class AddStaffScreen extends StatelessWidget {
  const AddStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddStaffController>();
    
    return Scaffold(
      body: Column(
        children: [
          const Header(
            title: 'Nhân viên',
            showBackButton: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Obx(() => TextFormField(
                        controller: controller.nameController..text = controller.selectedName.value,
                        decoration: InputDecoration(
                          labelText: 'Tên nhân viên',
                          hintText: 'Nhập tên nhân viên...',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tên nhân viên';
                          }
                          if (value.length < 5) {
                            return 'Tên phải có ít nhất 5 ký tự';
                          }
                          return null;
                        },
                      )),
                      const SizedBox(height: 16),
                      Obx(() => TextFormField(
                        controller: controller.phoneController..text = controller.selectedPhone.value,
                        decoration: InputDecoration(
                          labelText: 'Số điện thoại',
                          hintText: 'Nhập số điện thoại...',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập số điện thoại';
                          }
                          if (value.length != 10) {
                            return 'Số điện thoại phải đủ 10 số';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Số điện thoại chỉ được chứa số';
                          }
                          return null;
                        },
                      )),
                      const SizedBox(height: 16),
                      Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedPosition.value,
                        decoration: InputDecoration(
                          labelText: 'Chức vụ',
                          prefixIcon: const Icon(Icons.work),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: ['Nhân viên phục vụ', 'Quản lý', 'Giám đốc']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: controller.setPosition,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng chọn chức vụ';
                          }
                          return null;
                        },
                      )),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controller.salaryController,
                        decoration: InputDecoration(
                          labelText: 'Lương',
                          hintText: 'Nhập lương nhân viên...',
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập lương';
                          }
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return 'Lương phải là số';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedSalaryType.value,
                        decoration: InputDecoration(
                          labelText: 'Loại lương',
                          prefixIcon: const Icon(Icons.access_time),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: ['Theo giờ', 'Theo tháng'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: controller.setSalaryType,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng chọn loại lương';
                          }
                          return null;
                        },
                      )),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controller.bankAccountController,
                        decoration: InputDecoration(
                          labelText: 'Số tài khoản - Tên ngân hàng',
                          hintText: 'Nhập số tài khoản - Tên ngân hàng...',
                          prefixIcon: const Icon(Icons.account_balance),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập số tài khoản - Tên ngân hàng';
                          }
                          if (value.length < 10) {
                            return 'Số tài khoản phải có ít nhất 10 số';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () async {
                          if (controller.formKey.currentState!.validate()) {
                            await controller.addStaff();
                            
                            Get.dialog(
                              AcceptStaffModal(
                                staffId: DateTime.now().toString(),
                                name: controller.nameController.text,
                                phone: controller.phoneController.text,
                                position: controller.selectedPosition.value,
                                salary: '${controller.salaryController.text} ${controller.selectedSalaryType.value}',
                              ),
                            ).then((_) => Get.back());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Thêm Nhân Viên',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}