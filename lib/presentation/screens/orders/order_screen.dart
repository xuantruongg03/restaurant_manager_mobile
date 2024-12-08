import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header(title: "Đơn hàng"),
        Expanded(
          child: Container(
            // Content của order screen
          ),
        ),
      ],
    );
  }
}