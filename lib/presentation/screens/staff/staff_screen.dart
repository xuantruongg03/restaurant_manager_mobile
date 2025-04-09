import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/data/models/staff/staff_modal.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/textfield_custom.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/staff/staff_controller.dart';
import 'package:restaurant_manager_mobile/utils/formats.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get controller
    final controller = Get.find<StaffController>();

    return Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(
              title: 'Nhân viên',
              showBackButton: true,
            ),
            _buildSearchBar(controller),
            _buildFilterButton(controller),
            const SizedBox(height: 10),
            _buildTableHeader(controller),
            Divider(height: 1, color: Colors.grey[300]),
            _buildStaffList(controller),
          ],
        ),
        // Floating action button (two button: edit and add)
        floatingActionButton: _buildFloattingButton(controller));
  }

  // Witget to show the delete button and search bar
  Widget _buildSearchBar(StaffController controller) {
    return Obx(
      () {
        bool isHasSelectedCheckbox = controller.hasSelected();

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 12,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (isHasSelectedCheckbox) {
                      controller.showDeleteConfirmDialog();
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.delete,
                            color: isHasSelectedCheckbox
                                ? Colors.grey[700]
                                : Colors.grey[400]),
                        const SizedBox(width: 8),
                        Text(
                          'Xóa',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isHasSelectedCheckbox
                                  ? Colors.grey[700]
                                  : Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextFieldCustom(
                  controller: controller.searchController,
                  hintText: 'Tìm kiếm nhân viên',
                  prefixIcon: PhosphorIconsRegular.magnifyingGlass,
                  onChanged: (value) {
                    controller.search.value = value;
                    controller.applyFilter();
                    controller.refreshAllCheckBox();
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildFilterButton(StaffController controller) {
    return Obx(() {
      return controller.staffList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      openFilterDialog(controller);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.filter_alt, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Text(
                            controller.filteredRole.value,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink();
    });
  }

  void openFilterDialog(StaffController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text("Lọc theo chức vụ"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.filterOptions.length,
            itemBuilder: (context, index) {
              final role = controller.filterOptions[index];
              return Obx(() => RadioListTile<String>(
                    title: Text(role),
                    value: role,
                    groupValue: controller.filteredRole.value,
                    onChanged: (value) {
                      controller.filteredRole.value = value!;
                      controller.applyFilter();
                      Get.back(); // đóng dialog sau khi chọn
                    },
                  ));
            },
          ),
        ),
      ),
    );
  }

  // Widget to show header of table
  Widget _buildTableHeader(StaffController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      color: Colors.white,
      child: Row(
        children: [
          Obx(() =>
              _buildCheckbox(controller.isSelectAll.value, onChanged: (v) {
                controller.toggleCheckBoxAll();
              })),
          Expanded(
              child: _buildSortableColumn('Tên',
                  onTap: () =>
                      controller.sortBy('name', controller.isNameAscending))),
          Expanded(
              child: _buildSortableColumn('Chức vụ',
                  onTap: () => controller.sortBy(
                      'position', controller.isPositionAscending))),
          Expanded(
              child: _buildSortableColumn('Lương',
                  onTap: () => controller.sortBy(
                      'salary', controller.isSalaryAscending))),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  // Widget to show contains staff list
  Widget _buildStaffList(StaffController controller) {
    return Obx(() {
      final staffList = controller.filteredStaff;

      if (controller.isLoading.value) {
        return const Center(
            child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator()
          ],
        ));
      }

      if (staffList.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text('Chưa có nhân viên nào'),
          ),
        );
      }

      return Expanded(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchStaffList(); // Load lại danh sách
            controller.refreshAllCheckBox(); // Nếu cần reset các checkbox
            controller.applyFilter(); // Áp lại filter nếu đang dùng
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // Bắt buộc phải có
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: controller.filteredStaff.map((staff) {
                return _buildStaffRow(staff, controller);
              }).toList(),
            ),
          ),
        ),
      );
    });
  }

  // Widget to show info for each row staff (show info of staff)
  Widget _buildStaffRow(StaffModel staff, StaffController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            staff.isExpanded.value = !staff.isExpanded.value;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            color: staff.isExpanded.value ? Colors.white : AppColors.background,
            child: Row(
              children: [
                Obx(() =>
                    _buildCheckbox(staff.isSelected.value, onChanged: (v) {
                      staff.isSelected.value = v!;
                      controller.refreshCheckBoxAll();
                    })),
                Expanded(
                    child:
                        Text(staff.name, style: const TextStyle(fontSize: 14))),
                Expanded(
                    child:
                        Text(staff.role, style: const TextStyle(fontSize: 14))),
                Expanded(
                    child: Text(formatMoney(staff.payment),
                        style: const TextStyle(fontSize: 14))),
                IconButton(
                  icon: Icon(
                    staff.isExpanded.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[0],
                  ),
                  onPressed: () {
                    staff.isExpanded.value = !staff.isExpanded.value;
                  },
                ),
              ],
            ),
          ),
        ),
        Obx(() => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (widget, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1.0,
                  child: widget,
                );
              },
              child: staff.isExpanded.value
                  ? Container(
                      key: ValueKey(staff
                          .userId), // Giúp AnimatedSwitcher nhận diện thay đổi
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ngày vào làm: ${staff.workStartDate}'),
                              Text('Số tài khoản: ${staff.bankAccountNumber}'),
                              Text('Tổng công: ${staff.shifts}'),
                              Text(
                                  'Lương: ${formatMoney(staff.baseSalary)} / ${staff.type == 'FullTime' ? 'ngày' : 'giờ'}'),
                            ],
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Get.toNamed(RouteNames.workSchedule,
                                  arguments: staff),
                              borderRadius: BorderRadius.circular(5),
                              splashColor:
                                  Colors.grey.withOpacity(0.2), // Hiệu ứng nhấn
                              highlightColor: Colors.grey
                                  .withOpacity(0.1), // Hiệu ứng giữ lâu
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        const Text(
                                          'Xem chi tiết',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Container(
                                          width: 90,
                                          height: 1,
                                          color: AppColors.primary,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    controller.currentRole.value != 'Owner'
                                        ? InkWell(
                                            onTap: () {
                                              Get.toNamed(RouteNames.addStaff,
                                                      arguments: staff)
                                                  ?.then((_) {
                                                controller.fetchStaffList();
                                              });
                                            },
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Icon(Icons.edit,
                                                  color: Colors.grey[700]),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            )),
        Divider(height: 1, color: Colors.grey[300]),
      ],
    );
  }

  // Widget to show checkbox circle
  Widget _buildCheckbox(bool value, {required ValueChanged<bool?> onChanged}) {
    return SizedBox(
      width: 40,
      child: Checkbox(
        value: value,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4)), // Hình vuông
        checkColor: Colors.white,
        activeColor: Colors.blue,
        onChanged: onChanged,
      ),
    );
  }

  // Widget to show header title have sort features
  Widget _buildSortableColumn(String title, {VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.black.withOpacity(0.2),
        highlightColor: Colors.black.withOpacity(0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Icon(Icons.swap_vert, size: 18, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  // Widget to show button
  Widget _buildFloattingButton(StaffController controller) {
    return Stack(
      children: [
        Positioned(
          bottom: 15,
          right: 15,
          child: FloatingActionButton(
            onPressed: () {
              Get.toNamed(RouteNames.addStaff)?.then((_) {
                controller.fetchStaffList();
              });
            },
            backgroundColor: Colors.white,
            foregroundColor: const Color.fromARGB(255, 92, 90, 90),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
