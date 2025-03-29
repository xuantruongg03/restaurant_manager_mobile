import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/staff/work_schedule_controller.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/textfield_custom.dart';

class WorkScheduleScreen extends StatelessWidget {
  const WorkScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get controller
    final controller = Get.find<WorkScheduleController>();

    return Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => controller.isAdmin.value
                ? Header(
                    title: 'Lịch làm việc',
                    showBackButton: true,
                    showActionButton: true,
                    actionButtonText: 'Báo cáo',
                    onActionPressed: () {
                      showReportProblem();
                    },
                  )
                : const Header(
                    title: "Lịch làm việc",
                    showBackButton: true,
                  )),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                    .onDrag, // Ẩn bàn phím khi cuộn
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(controller),
                    _buildStaffInfo(),
                    _buildCalendar(controller),
                    _buildTest(controller),
                    _buildTable(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: _buildFloattingButton(controller));
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
  Widget _buildStaffInfo() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.5),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white),
          child: const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tên nhân viên: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Text('Liliana nè', style: TextStyle(fontSize: 16))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chức vụ: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Text('Nhân viên', style: TextStyle(fontSize: 16))
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Số điện thoại: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Text('0339643240', style: TextStyle(fontSize: 16))
                    ],
                  ),
                  SizedBox(
                    width: 90,
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Future<void> _selectDate(
      BuildContext context, WorkScheduleController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      controller.selectedDate.value = pickedDate;
    }
  }

  // Widget to show calendar
  Widget _buildCalendar(WorkScheduleController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                    "Chọn ngày: ${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  )),
              IconButton(
                icon: Icon(Icons.calendar_month, color: Colors.grey[500]),
                onPressed: () =>
                    _selectDate(Get.context!, controller), // Gọi hàm chọn ngày
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTest(WorkScheduleController controller) {
    DateTime now = DateTime.now();
    int todayWeekday = now.weekday; // Lấy thứ hiện tại (1 = Monday, 7 = Sunday)
    DateTime monday =
        now.subtract(Duration(days: todayWeekday - 1)); // Tính thứ 2 của tuần

    List<Map<String, String>> weekDays = List.generate(7, (index) {
      DateTime day = monday.add(Duration(days: index)); // Tính ngày từng thứ
      return {
        'day': DateFormat('E').format(day), // Lấy tên thứ (Mon, Tue, ...)
        'date': DateFormat('d').format(day), // Lấy ngày (24, 25, 26, ...)
      };
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Danh sách ngày trong tuần
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weekDays.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  bool isSelected = index == controller.selectedIndex.value;
                  return GestureDetector(
                    onTap: () {
                      controller.selectedIndex.value =
                          index; // Cập nhật giá trị
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
                            weekDays[index]['day']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  isSelected ? Colors.white : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            weekDays[index]['date']!,
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
                });
              },
            ),
          )
        ],
      ),
    );
  }

  // Widget to show table
  Widget _buildTable() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
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
              TableRow(
                  decoration: const BoxDecoration(color: Colors.white),
                  children: [
                    _buildTableCell('04/09/2024'),
                    _buildTableCell('18:00 - 21:00'),
                    _buildTableCellWithIcon(Icons.remove_red_eye),
                  ]),
              TableRow(
                  decoration: const BoxDecoration(color: Colors.white),
                  children: [
                    _buildTableCell('05/09/2024'),
                    _buildTableCell('17:00 - 21:00'),
                    _buildTableCellWithIcon(Icons.remove_red_eye),
                  ]),
            ],
          ),
          const SizedBox(height: 10), // Khoảng cách với tổng công
          const Text('Tổng công: 18 tiếng',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15))
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
  Widget _buildTableCellWithIcon(IconData icon) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            showSiftDetails();
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.grey.withOpacity(0.3),
          child: Icon(icon, color: Colors.grey[500]),
        ),
      ),
    );
  }

  // Widget to show button
  Widget _buildFloattingButton(WorkScheduleController controller) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      tooltip: 'Thêm lịch làm việc',
      onPressed: () {
        showTimeSelectionDialog(controller);
      },
      child: const Icon(Icons.add),
    );
  }

  void showTimeSelectionDialog(WorkScheduleController controller) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề + Nút đóng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Chọn thời gian làm",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  )
                ],
              ),
              const SizedBox(height: 10),

              // Ô nhập ngày
              _buildInputField("Ngày", Icons.calendar_today, () {
                _selectDate(Get.context!, controller);
              }),

              const SizedBox(height: 10),

              // Ô nhập thời gian bắt đầu và kết thúc
              Row(
                children: [
                  Expanded(
                    child: _buildInputField("Bắt đầu", Icons.access_time,
                        () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: Get.context!,
                        initialTime:
                            TimeOfDay.now(), // Giờ mặc định là hiện tại
                      );

                      if (pickedTime != null) {
                        // Xử lý giờ được chọn (hiển thị hoặc lưu lại)
                        print(
                            "Giờ được chọn: ${pickedTime.format(Get.context!)}");
                      }
                    }),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInputField("Kết thúc", Icons.access_time, () {
                      // Xử lý chọn giờ kết thúc
                    }),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Nút Lưu
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: () {
                  // Xử lý lưu
                  Get.back();
                },
                child: const Text("Lưu"),
              ),

              const SizedBox(height: 10),

              // Nút Hủy
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 45),
                  side: const BorderSide(color: AppColors.primary, width: 1),
                ),
                onPressed: () {
                  Get.back();
                },
                child: const Text("Hủy"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show shift details
  void showSiftDetails() {
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
              const Text(
                'Ngày làm: 28/04/2025',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Quản lý: Ana nè',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Ghi chú: Bể ly',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildImageMini(),
                  const SizedBox(
                    width: 10,
                  ),
                  _buildImageMini(),
                  const SizedBox(
                    width: 10,
                  ),
                  _buildImageMini(),
                  const SizedBox(
                    width: 10,
                  ),
                ],
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

// Widget to buil image mini
  Widget _buildImageMini(
      {double width = 60, String filePath = 'assets/images/empty-image.png'}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        filePath,
        width: width,
        height: width,
        fit: BoxFit.cover,
      ),
    );
  }

// Widget input field cho ngày & giờ
  Widget _buildInputField(String label, IconData icon, VoidCallback onTap) {
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
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            Icon(icon, color: Colors.black54, size: 20),
          ],
        ),
      ),
    );
  }

  // Show report proble
  void showReportProblem() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: "Nhập nội dung báo cáo...",
                  hintStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  border: InputBorder.none, // Ẩn viền
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  _buildImageMini(),
                  const SizedBox(
                    width: 10,
                  ),
                  _buildImageMini(),
                  const SizedBox(
                    width: 10,
                  ),
                  _buildImageMini(),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              // Nút Lưu
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: () {
                  // Xử lý lưu
                  Get.back();
                },
                child: const Text("Lưu"),
              ),

              const SizedBox(height: 10),

              // Nút Hủy
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 45),
                  side: const BorderSide(color: AppColors.primary, width: 1),
                ),
                onPressed: () {
                  Get.back();
                },
                child: const Text("Hủy"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
