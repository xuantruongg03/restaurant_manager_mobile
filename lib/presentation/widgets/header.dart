import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';

class Header extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final bool showActionButton;
  final VoidCallback? onActionPressed;
  final String actionButtonText;
  final bool? showNotificationButton;
  final VoidCallback? onNotificationPressed;
  final bool? showSettingButton;
  final VoidCallback? onSettingPressed;

  const Header({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.showActionButton = false,
    this.onActionPressed,
    this.actionButtonText = 'Thêm',
    this.showNotificationButton,
    this.onNotificationPressed,
    this.showSettingButton,
    this.onSettingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showBackButton)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            Padding(
                padding: EdgeInsets.only(left: showBackButton ? 0 : 10),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: showBackButton && showActionButton
                      ? TextAlign.center
                      : TextAlign.left,
                )),
            Container(
              width: showActionButton 
                  ? null 
                  : ((showNotificationButton ?? false) && (showSettingButton ?? false)) 
                      ? 60 
                      : 35,
              height: 40,
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              alignment: Alignment.centerRight,
              child: showActionButton 
                  ? TextButton(
                      onPressed: onActionPressed,
                      child: Text(
                        actionButtonText, 
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 16, 
                          fontWeight: FontWeight.w500
                        )
                      ),
                    )
                  : GridView.count(
                      padding: EdgeInsets.zero,
                      crossAxisCount: ((showNotificationButton ?? false) &&
                              (showSettingButton ?? false))
                          ? 2
                          : 1,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                      childAspectRatio: 1.0,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        if (showNotificationButton != null && showNotificationButton!)
                          Center(
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                PhosphorIconsBold.checks,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: onNotificationPressed,
                            ),
                          ),
                        if (showSettingButton != null && showSettingButton!)
                          Center(
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                PhosphorIconsBold.gear,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: onSettingPressed,
                            ),
                          ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
