import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/models/payment/payment_modal.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class PaymentRepository extends GetConnect {
  Future<bool> createPayment(PaymentModel payment) async {
    final storage = await StorageService.getInstance();
    try {
      final response = await ApiClient.post(
        '/payment/create-payment',
        headers: {
          'Authorization': 'Bearer ${storage.getString(StorageKeys.token)}',
        },
        body: payment.toJson(),
      );
      return response['success'];
    } catch (e) {
      return false;
    }
  }

  Future<PaymentModel> getPayment() async {
    final storage = await StorageService.getInstance();
    const idUser = "d19a3821-003f-4ec8-a136-9a32c8e07de0";
    // final idUser = storage.getString(StorageKeys.userId);
    final response = await ApiClient.get(
        '/payment/get/$idUser',
        headers: {
          'Authorization': 'Bearer ${storage.getString(StorageKeys.token)}',
        });
    return PaymentModel.fromJson(response['data']['result']);
  }

  Future<bool> updatePayment(PaymentModel payment) async {
    final storage = await StorageService.getInstance();
    final response = await ApiClient.post(
      '/payment/update-payment',
      headers: {
        'Authorization': 'Bearer ${storage.getString(StorageKeys.token)}',
      },
      body: payment.toJson(),
    );
    return response['success'];
  }
}
