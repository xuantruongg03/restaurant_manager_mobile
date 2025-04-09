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
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 15),
                      Obx(() => TextFormField(
                            controller: controller.nameController
                              ..text = controller.selectedName.value,
                            decoration: InputDecoration(
                              labelText: 'Tên nhân viên',
                              hintText: 'Nhập tên nhân viên...',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.grey[600],
                              ),
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
                      const SizedBox(height: 20),
                      Obx(() => TextFormField(
                            controller: controller.phoneController
                              ..text = controller.selectedPhone.value,
                            decoration: InputDecoration(
                              labelText: 'Số điện thoại',
                              hintText: 'Nhập số điện thoại...',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon:
                                  Icon(Icons.phone, color: Colors.grey[600]),
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
                      const SizedBox(height: 20),
                      Obx(() => DropdownButtonFormField<String>(
                            value: controller.selectedPosition.value,
                            decoration: InputDecoration(
                              labelText: 'Chức vụ',
                              prefixIcon: Icon(
                                Icons.work,
                                color: Colors.grey[600],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: [
                              'Quản lý',
                              'Đầu bếp',
                              'Phục vụ',
                              'Bảo vệ',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
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
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: controller.salaryController,
                        decoration: InputDecoration(
                          labelText: 'Lương',
                          hintText: 'Nhập lương nhân viên...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(
                            Icons.attach_money,
                            color: Colors.grey[600],
                          ),
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
                      const SizedBox(height: 20),
                      Obx(() => DropdownButtonFormField<String>(
                            value: controller.selectedSalaryType.value,
                            decoration: InputDecoration(
                              labelText: 'Loại lương',
                              prefixIcon: Icon(Icons.access_time,
                                  color: Colors.grey[600]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: ['FullTime', 'PartTime'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
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
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: controller.bankNameController
                          ..text = controller.selectedBankName.value,
                        decoration: InputDecoration(
                          labelText: 'Tên ngân hàng',
                          hintText: 'Tên ngân hàng...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.account_balance,
                              color: Colors.grey[600]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tên ngân hàng';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: controller.bankNumberController
                          ..text = controller.selectedBankNumber.value,
                        decoration: InputDecoration(
                          labelText: 'Số tài khoản',
                          hintText: 'Nhập số tài khoản',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon:
                              Icon(Icons.credit_card, color: Colors.grey[600]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập số tài khoản';
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
                          bool responseResult = false;
                          if (controller.formKey.currentState!.validate()) {
                            if (!controller.isEdit.value) {
                              responseResult = await controller.addStaff();
                            } else {
                              responseResult = await controller
                                  .updateStaff(controller.staff!.userId);
                            }
                          }

                          if (responseResult) {
                            Get.dialog(
                              AcceptStaffModal(
                                name: controller.nameController.text,
                                phone: controller.phoneController.text,
                                position: controller.selectedPosition.value,
                                salary:
                                    '${controller.salaryController.text} ${controller.selectedSalaryType.value}',
                                actionType: !controller.isEdit.value
                                    ? 'create'
                                    : 'update',
                              ),
                            ).then((_) => Get.back());
                          } else {
                            return;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          !controller.isEdit.value
                              ? 'Thêm nhân viên'
                              : 'Chỉnh sửa nhân viên',
                          style: const TextStyle(
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
