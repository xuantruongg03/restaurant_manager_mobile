import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/repositories/menus/menu_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/menus/menu_controller.dart';

class AddMenuController extends GetxController {
  final MenuRepository repository;

  AddMenuController({required this.repository});

  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  void addMenu() async {
    if (formKey.currentState!.validate()) {
      final response = await repository.createMenu(nameController.text);
      if (response != null) {
        Get.find<MenusController>().fetchMenuItems();
        Get.back();
      }
    }
  }
}
