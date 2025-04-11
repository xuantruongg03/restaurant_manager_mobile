import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_manager_mobile/data/models/staff/create_report_request.dart';
import 'package:restaurant_manager_mobile/data/models/staff/create_work_day_staff_model.dart';
import 'package:restaurant_manager_mobile/data/models/staff/report_detail_resonse.dart';
import 'package:restaurant_manager_mobile/data/models/staff/staff_modal.dart';
import 'package:restaurant_manager_mobile/data/models/staff/work_day_staff_modal.dart';
import 'package:restaurant_manager_mobile/data/repositories/report/report_repository.dart';
import 'package:restaurant_manager_mobile/data/repositories/staff/staff_repository.dart';
import 'package:restaurant_manager_mobile/data/repositories/staff/work_schedule_repository.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/yn_modal.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';
import 'package:restaurant_manager_mobile/utils/formats.dart';
import 'package:http/http.dart' as http;

class WorkScheduleController extends GetxController {
  final WorkScheduleRepository workScheduleRepository;
  final StaffRepository staffRepository;
  final ReportRepository reportRepository;

  WorkScheduleController(
      {required this.workScheduleRepository,
      required this.staffRepository,
      required this.reportRepository});

  // late StaffModel staff;
  final Rx<StaffModel?> staff = Rx<StaffModel?>(null);
  final RxList<StaffModel> staffList = <StaffModel>[].obs;
  final Rx<StaffModel?> filteredStaff = Rx<StaffModel?>(null);
  final RxList<WorkDayStaffModal> workDayList = <WorkDayStaffModal>[].obs;
  final RxList<WorkDayStaffModal> filteredWorkDays = <WorkDayStaffModal>[].obs;

  final RxString errorMessage = ''.obs;
  final RxBool isLoading = true.obs;
  final RxBool isStaffListLoading = true.obs;

  final TextEditingController searchController = TextEditingController();
  final RxString search = ''.obs;
  final RxString currentRole = ''.obs;
  final RxBool isOwner = true.obs;

  Rxn<DateTime> selectedDateToShowWorkDay = Rxn<DateTime>();
  Rxn<DateTime> selectedDate = Rxn<DateTime>();
  Rxn<TimeOfDay> startTime = Rxn<TimeOfDay>();
  Rxn<TimeOfDay> endTime = Rxn<TimeOfDay>();
  final RxBool isUploadLoading = false.obs;

  List<DateTime> getCurrentWeek(DateTime selectedDate) {
    int weekday = selectedDate.weekday;
    DateTime monday = selectedDate.subtract(Duration(days: weekday - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  final RxList<String> uploadedImageUrls = <String>[].obs;
  final TextEditingController reportTextController = TextEditingController();
  final RxList<File> selectedLocalImages = <File>[].obs;

  final Rx<ReportDetailResponse?> reportDetailRespone =
      Rx<ReportDetailResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    isStaffListLoading.value = true;

    // Lắng nghe tìm kiếm
    ever(search, _handleSearchInput);

    // Lắng nghe khi chọn ngày => tự động lọc lại
    ever(selectedDateToShowWorkDay, (_) {
      _filterWorkDaysBySelectedDate();
    });

    _initAsync(); // Dùng async riêng để gọi await được
  }

  Future<void> _initAsync() async {
    try {
      await fetchStaffList();

      print(staffList);

      if (Get.arguments != null) {
        staff.value = Get.arguments as StaffModel;
      } else if (staffList.isNotEmpty) {
        staff.value = staffList[0];
      }

      filteredStaff.value = staff.value;

      await fetchWorkDays(); // Phải là await thật sự

      // Gán selectedDateToShowWorkDay sau khi workDayList có dữ liệu
      final now = DateTime.now();
      selectedDateToShowWorkDay.value = now;
    } catch (e) {
      errorMessage.value = 'Lỗi khi khởi tạo: $e';
    } finally {
      isStaffListLoading.value = false;
    }
  }

  // Xử lý tìm kiếm nhân viên
  void _handleSearchInput(String value) {
    if (value.trim().isEmpty) {
      if (Get.arguments != null) {
        filteredStaff.value = Get.arguments as StaffModel;
      } else if (staffList.isNotEmpty) {
        filteredStaff.value = staffList[0];
      } else {
        filteredStaff.value = null;
      }
    } else {
      final result = staffList.firstWhereOrNull(
        (s) => s.name.toLowerCase().contains(value.toLowerCase()),
      );
      filteredStaff.value = result;
    }
  }

  // Gọi API để lấy danh sách work day
  Future<void> fetchWorkDays() async {
    try {
      final now = DateTime.now();
      final data = await workScheduleRepository.getWorkDayByUserIdAndMonth(
          staff.value!.userId, now.month, now.year);
      workDayList.value = data;
    } catch (e) {
      errorMessage.value = 'Lỗi khi tải ngày làm việc: $e';
    }
  }

  // Gọi API để lấy danh sách nhân viên từ repository
  Future<void> fetchStaffList() async {
    try {
      final storageService = await StorageService.getInstance();
      currentRole.value = storageService.getString(StorageKeys.role) ?? 'Owner';
      isOwner.value = currentRole.value == 'Owner';
      // isOwner.value = false;

      final result = await staffRepository.getStaffList();

      if (result != null) {
        staffList.assignAll(result);
      }
    } catch (e) {
      errorMessage.value = 'Lỗi khi tải danh sách nhân viên: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReportDetail(String workDayId) async {
    try {
      print("Work day id: " + workDayId);
      reportDetailRespone.value =
          await reportRepository.getReportByWorkDayId(workDayId);
    } catch (e) {
      errorMessage.value =
          'Lỗi khi lấy thông tin chi tiết của ngày làm việc: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _filterWorkDaysBySelectedDate() {
    if (selectedDateToShowWorkDay.value == null) return;

    final selectedDateStr =
        DateFormat('dd/MM/yyyy').format(selectedDateToShowWorkDay.value!);

    filteredWorkDays.value = workDayList.where((workDay) {
      return formatWorkDate(workDay.workDate) == selectedDateStr;
    }).toList();
  }

  void showDeleteConfirmDialog(String workDayId) {
    Get.dialog(
      YNModal(
        title: "Xác nhận xóa!",
        content: "Bạn có chắc chắn muốn xóa ngày làm việc này không?",
        yesText: "Xóa",
        noText: "Hủy",
        onYes: (bool value) async {
          if (value) {
            workDayList.removeWhere((item) => item.idWorkDay == workDayId);
            await workScheduleRepository.deleteWorkDay(workDayId);
            await fetchWorkDays();
            _filterWorkDaysBySelectedDate();
          }
        },
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  Future<void> selectDateToShowWorkDay(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectedDateToShowWorkDay.value = picked;
    }
  }

  Future<void> selectTime(BuildContext context, bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      if (isStart) {
        startTime.value = picked;
      } else {
        endTime.value = picked;
      }
    }
  }

  void resetSelection() {
    selectedDate.value = null;
    startTime.value = null;
    endTime.value = null;
  }

  Future<void> createWorkDay() async {
    CreateWorkDayStaffModel asq = CreateWorkDayStaffModel(
        username: staff.value!.username,
        dateOff: '',
        workDay: convertDateTimeToYMD(selectedDate.value!),
        startTime: convertTimeOfDayToString(startTime.value!),
        endTime: convertTimeOfDayToString(endTime.value!));

    bool result = await workScheduleRepository.createWorkDay(asq);
    if (result) {
      await fetchWorkDays();
      _filterWorkDaysBySelectedDate();
      staff.value = filteredStaff.value;
      // staff.value = staffList.firstWhere(
      //   (s) => s.username == staff.value!.username,
      // );
    }
  }

  Future<void> updateWorkDay(String workDayId) async {
    WorkDayStaffModal wdsm = WorkDayStaffModal(
        idWorkDay: workDayId,
        workDate: convertDateTimeToYMD(selectedDate.value!),
        startTime: convertTimeOfDayToString(startTime.value!),
        endTime: convertTimeOfDayToString(endTime.value!));

    bool result = await workScheduleRepository.updateWorkDay(wdsm);
    if (result) {
      await fetchWorkDays();
      _filterWorkDaysBySelectedDate();
      await fetchStaffList();
      // staff.value = filteredStaff.value;
      staff.value = staffList.firstWhere(
        (s) => s.username == staff.value!.username,
      );
    }
  }

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> selected = await picker.pickMultiImage();

    if (selected.length + selectedLocalImages.length > 4) {
      Get.snackbar("Thông báo", "Chỉ được chọn tối đa 4 ảnh");
      return;
    }

    for (XFile image in selected) {
      final file = File(image.path);
      selectedLocalImages.add(file); // chỉ lưu ảnh local để hiển thị
    }
  }

  Future<String?> uploadImageToCloudinary(File imageFile) async {
    try {
      final String cloudName = dotenv.env['CLOUD_NAME'] ?? '';
      final String apiKey = dotenv.env['API_KEY'] ?? '';
      final String apiSecret = dotenv.env['API_SECRET'] ?? '';

      final uri =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', uri);

      request.fields['upload_preset'] = dotenv.env['UPLOAD_PRESET'] ?? '';
      request.fields['api_key'] = apiKey;
      request.fields['api_secret'] = apiSecret;
      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final data = jsonDecode(responseData.body);
        return data['secure_url'];
      } else {
        print('Failed to upload image: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> sendReport() async {
    isUploadLoading.value = true;
    final reportContent = reportTextController.text.trim();

    if (reportContent.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập nội dung báo cáo");
      return;
    }

    if (filteredWorkDays.isEmpty) {
      Get.snackbar("Lỗi", "Không tìm thấy ngày làm việc để báo cáo");
      return;
    }

    // Upload ảnh tại đây
    List<String> urls = [];
    for (File img in selectedLocalImages) {
      String? url = await uploadImageToCloudinary(img);
      if (url != null) urls.add(url);
    }

    CreateReportRequest crr = CreateReportRequest(
      idWorkDay: filteredWorkDays[0].idWorkDay,
      note: reportContent,
      imageUrls: urls,
    );

    try {
      bool result = await reportRepository.createReport(crr);

      if (result) {
        Get.back();
        Get.snackbar("Thành công", "Đã gửi báo cáo");
      } else {
        Get.snackbar("Lỗi", "Không thể gửi báo cáo");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Gửi báo cáo thất bại: $e");
    } finally {
      isUploadLoading.value = false;
      clearCreateReportForm();
    }
  }

  void clearCreateReportForm() {
    uploadedImageUrls.clear();
    reportTextController.clear();
    selectedLocalImages.clear();
  }
}
