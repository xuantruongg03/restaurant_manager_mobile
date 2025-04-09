import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/statistic/statistic_modal.dart';
import 'package:restaurant_manager_mobile/data/repositories/statistic/statistic_repository.dart';

class StatisticController extends GetxController {
  final StatisticRepository _statisticRepository = StatisticRepository();

  final RxList<StatisticModel> _statisticList = <StatisticModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStatistic();
  }

  Future<void> _loadStatistic() async {
    _isLoading.value = true;
    try {
      final statistic = await _statisticRepository.getStatistic();
      _statisticList.assignAll(statistic);
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  List<StatisticModel> get statisticList => _statisticList;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;

  void addStatistic(StatisticModel statistic) {
    _statisticList.add(statistic);
  }

  void updateStatistic(StatisticModel statistic) {
    final index = _statisticList.indexWhere((item) => item.id == statistic.id);
    if (index != -1) {
      _statisticList[index] = statistic;
    }
  }

  void deleteStatistic(String id) {
    _statisticList.removeWhere((statistic) => statistic.id == id);
  }

  void clearStatistic() {
    _statisticList.clear();
  }
}