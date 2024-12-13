import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/models/tables/table_modal.dart';

class TablesRepository {
  final ApiClient apiClient;

  TablesRepository({required this.apiClient});

  Future<List<TableModel>> getTables() async {
    try {
      
      final response = await ApiClient.get('/table/get');
      if (response['success'] == true) {
        return response['data']
            .map((json) => TableModel.fromJson(json))
            .toList();
      }
      throw Exception('Failed to fetch tables');
    } catch (e) {
      throw Exception('Failed to fetch tables: $e');
    }
  }
}
