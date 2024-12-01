import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';

class Header extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final bool showActionButton;
  final VoidCallback? onActionPressed;

  const Header({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.showActionButton = false,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (showBackButton)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: showBackButton && showActionButton ? TextAlign.center : TextAlign.left,
              ),
            ),
            if (showActionButton)
              GestureDetector(
                onTap: onActionPressed,
                child: const Text("Thêm", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              ),
          ],
        ),
      ),
    );
  }
}
