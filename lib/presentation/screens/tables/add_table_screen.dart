import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/presentation/layouts/main_layout.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/textfield_custom.dart';
class AddTableScreen extends StatelessWidget {
  const AddTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Header(
            title: 'Thêm bàn',
            showBackButton: true,
            showActionButton: true,
            onActionPressed: () {},
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
                        const TextFieldCustom(
                          hintText: 'Nhập tên bàn...',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  }
}
