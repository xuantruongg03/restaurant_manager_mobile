import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
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
            // _buildFilterButton(controller),
            const SizedBox(height: 10),
            _buildTableHeader(controller),
            Divider(height: 1, color: Colors.grey[300]),
            _buildStaffList(controller),
          ],
        ),
        // Floating action button (two button: edit and add)
        floatingActionButton: _buildFloattingButton());
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

  // Widget to show filter button
  Widget _buildFilterButton(StaffController controller) {
    return Obx(() {
      if (controller.filteredStaff.isNotEmpty) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end, // Đẩy nút sang phải
          children: [
            SizedBox(
              width: 80,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Lọc',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 3),
                        Icon(
                          Icons.filter_alt_rounded,
                          color: Colors.grey[700],
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            )
          ],
        );
      }
      return const SizedBox.shrink();
    });
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
                      controller.sortBy('name', controller.isNameyAscending))),
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

      if (staffList.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text('Chưa có nhân viên nào'),
          ),
        );
      }

      return Expanded(
          child: SingleChildScrollView(
        child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: controller.filteredStaff.map((staff) {
              return _buildStaffRow(staff, controller);
            }).toList()),
      ));
    });
  }

  // Widget to show info for each row staff (show info of staff)
  Widget _buildStaffRow(
      Map<String, dynamic> staff, StaffController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            staff['isExpanded'].value = !staff['isExpanded'].value;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            color:
                staff['isExpanded'].value ? Colors.white : AppColors.background,
            child: Row(
              children: [
                Obx(() =>
                    _buildCheckbox(staff['isChecked'].value, onChanged: (v) {
                      staff['isChecked'].value = v!;
                      controller.refreshCheckBoxAll();
                    })),
                Expanded(
                    child: Text(staff['name'],
                        style: const TextStyle(fontSize: 14))),
                Expanded(
                    child: Text(staff['position'],
                        style: const TextStyle(fontSize: 14))),
                Expanded(
                    child: Text(formatMoney(staff['salary']),
                        style: const TextStyle(fontSize: 14))),
                IconButton(
                  icon: Icon(
                    staff['isExpanded'].value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[0],
                  ),
                  onPressed: () {
                    staff['isExpanded'].value = !staff['isExpanded'].value;
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
              child: staff['isExpanded'].value
                  ? Container(
                      key: ValueKey(staff[
                          'id']), // Giúp AnimatedSwitcher nhận diện thay đổi
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ngày vào làm: ${staff['startDate']}'),
                              Text('Số tài khoản: ${staff['bankAccount']}'),
                              Text('Tổng cộng: ${staff['workHours']}'),
                              Text('Lương: ${staff['hourlyWage']}'),
                            ],
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Get.toNamed(RouteNames.workSchedule),
                              borderRadius: BorderRadius.circular(5),
                              splashColor:
                                  Colors.grey.withOpacity(0.2), // Hiệu ứng nhấn
                              highlightColor: Colors.grey
                                  .withOpacity(0.1), // Hiệu ứng giữ lâu
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
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
  Widget _buildFloattingButton() {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          child: FloatingActionButton(
            onPressed: () => Get.toNamed(RouteNames.addStaff),
            backgroundColor: Colors.white,
            foregroundColor: const Color.fromARGB(255, 92, 90, 90),
            child: const Icon(Icons.add),
          ),
        ),
        Positioned(
          bottom: 70,
          right: 0,
          child: FloatingActionButton(
            onPressed: () => Get.toNamed(RouteNames.addStaff),
            backgroundColor: Colors.white,
            foregroundColor: const Color.fromARGB(255, 92, 90, 90),
            child: const Icon(Icons.edit_outlined),
          ),
        ),
      ],
    );
  }
}
