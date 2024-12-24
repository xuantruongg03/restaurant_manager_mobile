import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/payment/payment_modal.dart';
import 'package:restaurant_manager_mobile/data/repositories/payment/payment_repository.dart';

class PaymentController extends GetxController {
  final PaymentRepository repository;

  PaymentController({required this.repository});

  final Rx<PaymentModel> payment = PaymentModel(partnercode: '', secretkey: '', accesskey: '').obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getPayment();
  }

  Future<void> getPayment() async {
    isLoading.value = true;
    try {
      final fetchedPayment = await repository.getPayment();
      payment.value = fetchedPayment;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createPayment() async {
    isLoading.value = true;
    try {
      final createdPayment = await repository.createPayment(payment.value);
      payment.value = createdPayment;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}