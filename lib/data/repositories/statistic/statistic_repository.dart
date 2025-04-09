import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/models/statistic/statistic_modal.dart';

class StatisticRepository {
  Future<List<StatisticModel>> getStatistic() async {
    final response = await ApiClient.get('/statistic/get-statistic');
    return (response['data'] as List)
        .map((item) => StatisticModel.fromJson(item))
        .toList();
  }

  Future<StatisticModel> createStatistic(StatisticModel statistic) async {
    final response = await ApiClient.post('/statistic/create-statistic', body: statistic.toJson());
    return StatisticModel.fromJson(response['data']);
  }

  Future<StatisticModel> updateStatistic(StatisticModel statistic) async {
    final response = await ApiClient.put('/statistic/update-statistic', body: statistic.toJson());
    return StatisticModel.fromJson(response['data']);
  }
}