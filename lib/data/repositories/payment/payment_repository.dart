import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/models/payment/payment_modal.dart';

class PaymentRepository extends GetConnect {
  Future<PaymentModel> createPayment(PaymentModel payment) async {
    final response = await ApiClient.post(
      '/payment/create-payment',
      body: payment.toJson(),
    );
    return PaymentModel.fromJson(response['data']);
  }
  Future<PaymentModel> getPayment() async {
    final response = await ApiClient.get('/payment/get-payment');
    return PaymentModel.fromJson(response['data']);
  }
  Future<PaymentModel> updatePayment(PaymentModel payment) async {
    final response = await ApiClient.put(
      '/payment/update-payment',
      body: payment.toJson(),
    );
    return PaymentModel.fromJson(response['data']);
  }
}