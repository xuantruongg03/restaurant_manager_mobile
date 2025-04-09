import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/payment/payment_modal.dart';
import 'package:restaurant_manager_mobile/data/repositories/payment/payment_repository.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';
import 'package:restaurant_manager_mobile/utils/functions.dart';

class PaymentController extends GetxController {
  final PaymentRepository repository;

  PaymentController({required this.repository});

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString idRestaurant = ''.obs;
  final RxString mode = 'create'.obs;
  final RxString idPayment = ''.obs;
  final TextEditingController partnercode = TextEditingController();
  final TextEditingController secretkey = TextEditingController();
  final TextEditingController accesskey = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    getPayment();
  }

  Future<void> getPayment() async {
    isLoading.value = true;
    try {
      final fetchedPayment = await repository.getPayment();
      partnercode.text = fetchedPayment.partnercode;
      secretkey.text = fetchedPayment.secretkey;
      accesskey.text = fetchedPayment.accesskey;
      idPayment.value = fetchedPayment.idPayment;
      mode.value = 'update';
    } catch (e) {
      Functions.showSnackbar("Lỗi lấy thanh toán");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createPayment() async {
    isLoading.value = true;
    try {
      final storage = await StorageService.getInstance();
      final idRestaurant = storage.getString(StorageKeys.restaurantId);
      final createdPayment = await repository.createPayment(PaymentModel(
          partnercode: partnercode.text,
          secretkey: secretkey.text,
          accesskey: accesskey.text,
          idPayment: '',
          idRestaurant: idRestaurant ?? ''));
      if (createdPayment) {
        Functions.showSnackbar("Tạo thanh toán thành công");
        Get.back();
      } else {
        Functions.showSnackbar('Tạo thanh toán thất bại');
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePayment() async {
    isLoading.value = true;
    try {
      final storage = await StorageService.getInstance();
      final idRestaurant = storage.getString(StorageKeys.restaurantId);
      final updatedPayment = await repository.updatePayment(PaymentModel(
          partnercode: partnercode.text,
          secretkey: secretkey.text,
          accesskey: accesskey.text,
          idPayment: idPayment.value,
          idRestaurant: idRestaurant ?? ''));
      if (updatedPayment) {
        Functions.showSnackbar("Cập nhật thanh toán thành công");
        Get.back();
      } else {
        Functions.showSnackbar('Cập nhật thanh toán thất bại');
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

