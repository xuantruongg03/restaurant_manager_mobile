import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/data/models/staff/create_work_day_staff_model.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/staff/work_schedule_controller.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/textfield_custom.dart';
import 'package:restaurant_manager_mobile/utils/formats.dart';

class WorkScheduleScreen extends StatelessWidget {
  const WorkScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy controller
    final controller = Get.find<WorkScheduleController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Obx(() => controller.isOwner.value
              ? Header(
                  title: 'Lịch làm việc',
                  showBackButton: true,
                  showActionButton: true,
                  actionButtonText: 'Báo cáo',
                  onActionPressed: () {
                    showReportProblem(controller);
                  },
                )
              : const Header(
                  title: "Lịch làm việc",
                  showBackButton: true,
                )),

          // Loading indicator khi đang tải dữ liệu danh sách nhân viên
          Obx(() {
            if (controller.isStaffListLoading.value) {
              return const Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    CircularProgressIndicator()
                  ],
                ),
              );
            } else {
              return Expanded(
                child: Obx(
                  () => SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar
                        _buildSearchBar(controller),

                        // CircularProgressIndicator khi đang tải thông tin nhân viên
                        if (controller.isLoading.value)
                          const Center(
                            child: CircularProgressIndicator(),
                          ),

                        // Kiểm tra nếu danh sách nhân viên không rỗng
                        if (controller.staffList.isNotEmpty) ...[
                          _buildStaffInfo(controller),
                          _buildSelecDate(controller),
                          _buildCalendar(controller),
                          _buildTable(controller),
                          const SizedBox(height: 10),
                        ] else
                          // Nếu danh sách nhân viên rỗng, hiển thị thông báo
                          const Center(
                            child: Text("Không có dữ liệu nhân viên."),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
        ],
      ),
      floatingActionButton: _buildFloattingButton(controller),
    );
  }

  // Witget to show the delete button and search bar
  Widget _buildSearchBar(WorkScheduleController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFieldCustom(
        controller: controller.searchController,
        hintText: 'Tìm kiếm nhân viên',
        prefixIcon: PhosphorIconsRegular.magnifyingGlass,
        onChanged: (value) => controller.search.value = value,
      ),
    );
  }

  // Widget to show info basic of staff
  Widget _buildStaffInfo(WorkScheduleController controller) {
    return Obx(() {
      final staff = controller.filteredStaff.value;
      if (staff == null) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text("Không tìm thấy nhân viên."),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.5),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tên nhân viên: ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        Text(staff.name, style: const TextStyle(fontSize: 16))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Chức vụ: ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        Text(staff.role, style: const TextStyle(fontSize: 16))
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Số điện thoại: ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        Text(staff.phone, style: const TextStyle(fontSize: 16))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Loại lương: ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        Text(staff.type, style: const TextStyle(fontSize: 16))
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  // Widget to show calendar
  Widget _buildSelecDate(WorkScheduleController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                final selected = controller.selectedDateToShowWorkDay.value;
                final text = selected != null
                    ? "Chọn ngày: ${selected.day}/${selected.month}/${selected.year}"
                    : "Chưa chọn ngày";

                return Text(
                  text,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                );
              }),
              IconButton(
                icon: Icon(Icons.calendar_month, color: Colors.grey[500]),
                onPressed: () =>
                    controller.selectDateToShowWorkDay(Get.context!),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(WorkScheduleController controller) {
    return Obx(() {
      DateTime selectedDate =
          controller.selectedDateToShowWorkDay.value ?? DateTime.now();
      List<DateTime> weekDays = controller.getCurrentWeek(selectedDate);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    controller.selectedDateToShowWorkDay.value = controller
                        .selectedDateToShowWorkDay.value!
                        .subtract(const Duration(days: 7));
                  },
                ),
                Text(
                  "Tuần của ${DateFormat('dd/MM').format(weekDays.first)} - ${DateFormat('dd/MM').format(weekDays.last)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    controller.selectedDateToShowWorkDay.value = controller
                        .selectedDateToShowWorkDay.value!
                        .add(const Duration(days: 7));
                  },
                ),
              ],
            ),
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: weekDays.length,
                itemBuilder: (context, index) {
                  final date = weekDays[index];
                  final isSelected = date.day == selectedDate.day &&
                      date.month == selectedDate.month &&
                      date.year == selectedDate.year;

                  return GestureDetector(
                    onTap: () {
                      controller.selectedDateToShowWorkDay.value = date;
                    },
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('E', 'vi_VN').format(date),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  isSelected ? Colors.white : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            DateFormat('d').format(date),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  isSelected ? Colors.white : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );
    });
  }

  // Widget to show table
  Widget _buildTable(WorkScheduleController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Table(
            border: TableBorder.all(color: Colors.grey, width: 1),
            children: [
              // Hàng tiêu đề
              TableRow(
                decoration: BoxDecoration(
                    color: Colors.grey[300]), // Màu nền cho header
                children: [
                  _buildTableCell('Ngày', isHeader: true),
                  _buildTableCell('Giờ', isHeader: true),
                  _buildTableCell('Hành động', isHeader: true),
                ],
              ),
              // Hàng dữ liệu
              // Dữ liệu từ workDayList
              ...controller.filteredWorkDays.map((item) {
                final workDateFormatted = formatWorkDate(item.workDate);
                final startTime = formatWorkTime(item.startTime);
                final endTime = formatWorkTime(item.endTime);
                final timeRange = '$startTime - $endTime';
                return TableRow(
                  decoration: const BoxDecoration(color: Colors.white),
                  children: [
                    _buildTableCell(workDateFormatted),
                    _buildTableCell(timeRange),
                    controller.isOwner.value
                        ? _buildTableCellWithTwoIcons(
                            onEdit: () {
                              showCreateWorkDayTimeDialog(controller,
                                  data: CreateWorkDayStaffModel(
                                      username: controller.staff.username,
                                      dateOff: '',
                                      workDay: workDateFormatted,
                                      startTime: startTime,
                                      endTime: endTime),
                                  workDayId: item.idWorkDay);
                            },
                            onDelete: () {
                              controller
                                  .showDeleteConfirmDialog(item.idWorkDay);
                            },
                          )
                        : _buildTableCellWithIcon(
                            controller,
                            Icons.remove_red_eye,
                            workDateFormatted,
                            item.idWorkDay),
                  ],
                );
              }),
            ],
          ),
          if (controller.filteredWorkDays.isEmpty)
            Center(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Không có thông tin phù hợp',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700]),
              ),
            )),
          const SizedBox(height: 10), // Khoảng cách với tổng công
          if (controller.filteredWorkDays.isNotEmpty)
            Text('Tổng công: ${controller.staff.shifts} tiếng',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 15))
        ],
      ),
    );
  }

  /// Widget hỗ trợ căn giữa nội dung trong TableCell và thêm padding
  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Padding cho từng ô
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }

  /// Widget hỗ trợ căn giữa icon trong ô TableCell
  Widget _buildTableCellWithIcon(WorkScheduleController controller,
      IconData icon, String workDateFormatted, String idWorkDay) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            showSiftDetails(controller, workDateFormatted, idWorkDay);
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.grey.withOpacity(0.3),
          child: Icon(icon, color: Colors.grey[500]),
        ),
      ),
    );
  }

  Widget _buildTableCellWithTwoIcons({
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(16),
              splashColor: Colors.grey.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.edit, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: onDelete,
              borderRadius: BorderRadius.circular(16),
              splashColor: Colors.grey.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.delete, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to show button
  Widget _buildFloattingButton(WorkScheduleController controller) {
    return Stack(
      children: [
        Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              tooltip: 'Thêm lịch làm việc',
              onPressed: () {
                showCreateWorkDayTimeDialog(controller);
              },
              child: const Icon(Icons.add),
            ))
      ],
    );
  }

  void showCreateWorkDayTimeDialog(WorkScheduleController controller,
      {CreateWorkDayStaffModel? data, String? workDayId}) {
    controller.resetSelection();

    if (data != null) {
      controller.selectedDate.value =
          DateFormat('dd/MM/yyyy').parse(data.workDay);
      controller.startTime.value = parseTimeStringToTimeOfDay(data.startTime);
      controller.endTime.value = parseTimeStringToTimeOfDay(data.endTime);
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Chọn thời gian làm",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Get.back())
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Ngày
                  _buildReactiveInput(
                    "Ngày",
                    Icons.calendar_today,
                    () => controller.selectDate(Get.context!),
                    controller.selectedDate.value != null
                        ? DateFormat('dd/MM/yyyy')
                            .format(controller.selectedDate.value!)
                        : "Chọn ngày",
                  ),
                  const SizedBox(height: 10),

                  // Giờ bắt đầu & kết thúc
                  Row(
                    children: [
                      Expanded(
                        child: _buildReactiveInput(
                          "Bắt đầu",
                          Icons.access_time,
                          () => controller.selectTime(Get.context!, true),
                          controller.startTime.value?.format(Get.context!) ??
                              "Bắt đầu",
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildReactiveInput(
                          "Kết thúc",
                          Icons.access_time,
                          () => controller.selectTime(Get.context!, false),
                          controller.endTime.value?.format(Get.context!) ??
                              "Kết thúc",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    onPressed: () {
                      // Kiểm tra dữ liệu đã đủ chưa
                      if (controller.selectedDate.value == null) {
                        Get.snackbar(
                          "Lỗi",
                          "Vui lòng chọn ngày làm việc",
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      if (controller.startTime.value == null ||
                          controller.endTime.value == null) {
                        Get.snackbar(
                          "Lỗi",
                          "Vui lòng chọn giờ bắt đầu và giờ kết thúc",
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      if (data == null && workDayId == null) {
                        controller.createWorkDay();
                      } else {
                        controller.updateWorkDay(workDayId!);
                      }

                      Get.back();
                    },
                    child: const Text("Lưu"),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 45),
                      side:
                          const BorderSide(color: AppColors.primary, width: 1),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text("Hủy"),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  // Show shift details
  void showSiftDetails(WorkScheduleController controller,
      String workDateFormatted, String idWorkDay) async {
    await controller.fetchReportDetail(idWorkDay);

    if (controller.reportDetailRespone.value == null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Không có thông tin chi tiết để xem')),
        );
        return;
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề + Nút đóng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Chi tiết ca làm",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Text(
                'Ngày làm: $workDateFormatted',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Ghi chú: ${controller.reportDetailRespone.value!.note}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              // Kiểm tra nếu có ảnh
              if ((controller
                      .reportDetailRespone.value?.reportImages?.isNotEmpty ??
                  false))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller
                          .reportDetailRespone.value!.reportImages.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final imageUrl = controller
                            .reportDetailRespone.value!.reportImages[index].url;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 15),
              // Nút Lưu
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: () {
                  // Xử lý lưu
                  Get.back();
                },
                child: const Text("Lưu"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReactiveInput(
      String label, IconData icon, VoidCallback onTap, String value) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            Icon(icon, color: Colors.black54, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerRow(WorkScheduleController controller) {
    return Obx(() => Row(
          children: List.generate(4, (index) {
            if (index < controller.selectedLocalImages.length) {
              return _buildImageMini(
                FileImage(controller.selectedLocalImages[index]),
              );
            } else {
              return _buildImageMini(null, onTap: controller.pickImages);
            }
          }),
        ));
  }

  Widget _buildImageMini(ImageProvider? image, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          image: image != null
              ? DecorationImage(image: image, fit: BoxFit.cover)
              : null,
        ),
        child: image == null ? const Icon(Icons.add_a_photo) : null,
      ),
    );
  }

  // Show report proble
  void showReportProblem(WorkScheduleController controller) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // Đề phòng bàn phím tràn
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề + Nút đóng
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Báo cáo sự cố",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    )
                  ],
                ),
                const SizedBox(height: 16),

                // Nhập nội dung báo cáo
                TextField(
                  controller: controller.reportTextController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "Nhập nội dung báo cáo...",
                    hintStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Ảnh đã chọn / thêm ảnh
                _buildImagePickerRow(controller),
                const SizedBox(height: 16),

                // Nút Lưu
                Obx(() {
                  return controller.isUploadLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 45),
                          ),
                          onPressed: controller.sendReport,
                          child: const Text("Lưu"),
                        );
                }),
                const SizedBox(height: 10),

                // Nút Hủy
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 45),
                    side: const BorderSide(color: AppColors.primary, width: 1),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text("Hủy"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
