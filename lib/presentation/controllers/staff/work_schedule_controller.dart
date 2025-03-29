import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/repositories/staff/work_schedule_repository.dart';

class WorkScheduleController extends GetxController {
  final WorkScheduleRepository repository;

  final TextEditingController searchController = TextEditingController();
  final RxBool isAdmin = true.obs;
  final RxString search = ''.obs;
  final RxBool isCalendarVisible = false.obs;
  final selectedDate = DateTime.now().obs;
  final RxInt selectedIndex = 1.obs;

  WorkScheduleController({required this.repository});
}
