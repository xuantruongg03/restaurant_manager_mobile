import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/textfield_custom.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/tables/add_table_controller.dart';
import 'package:restaurant_manager_mobile/utils/permission_utils.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/permission_denied_modal.dart';

class AddTableScreen extends GetView<AddTableController> {
  const AddTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: PermissionUtils.checkPermission(['Owner', 'Manager']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data != true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.back();
            Get.dialog(const PermissionDeniedModal());
          });
          return const SizedBox.shrink();
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              Header(
                title: 'Thêm bàn',
                showBackButton: true,
                showActionButton: true,
                
                onActionPressed: () => controller.addTable(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: '* ',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'Đặt tên cho mỗi bàn, điều này sẽ giúp bạn dễ dàng quản lý và phân loại, đồng thời thu hút sự chú ý của khách hàng.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Tên bàn: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Form(
                              key: controller.formKey,
                              child: TextFieldCustom(
                                controller: controller.nameController,
                                hintText: 'Nhập tên bàn...',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập tên bàn';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
