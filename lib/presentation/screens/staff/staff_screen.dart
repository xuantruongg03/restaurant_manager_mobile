import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/textfield_custom.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/staff/staff_controller.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/yn_modal.dart';


class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StaffController>();
    
    return Scaffold(
      body: Column(
        children: [
          const Header(
            title: 'Nhân viên',
            showBackButton: true,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFieldCustom(
              hintText: 'Tìm kiếm nhân viên',
              prefixIcon: PhosphorIconsBold.magnifyingGlass,
              onChanged: (value) => controller.search.value = value,
            ),
          ),
          Expanded(
            child: Obx(() {
              final staffList = controller.filteredStaff;
              if (staffList.isEmpty) {
                return const Center(
                  child: Text('Chưa có nhân viên nào'),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: staffList.length,
                itemBuilder: (context, index) {
                  final staff = staffList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(
                        staff['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SĐT: ${staff['phone']}'),
                          Text('Chức vụ: ${staff['position']}'),
                          Text(
                            'Lương: ${staff['salary']} (${staff['salaryType']})',
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          Get.dialog(
                            YNModal(
                              title: 'Xóa nhân viên',
                              content: 'Bạn có chắc muốn xóa nhân viên này?',
                              yesText: 'Xóa',
                              noText: 'Hủy',
                              onYes: (bool value) {
                                controller.removeStaff(staff['id']);
                                Get.back();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(RouteNames.addStaff),
        child: const Icon(Icons.add),
      ),
    );
  }
}
