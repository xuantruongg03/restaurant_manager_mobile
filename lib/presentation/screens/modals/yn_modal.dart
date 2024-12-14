import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';

class YNModal extends StatefulWidget {
  final String title;
  final String content;
  final String yesText;
  final String noText;
  final Function(bool) onYes;
  final Function(bool)? onNo;

  const YNModal(
      {super.key,
      required this.title,
      required this.content,
      required this.yesText,
      required this.noText,
      required this.onYes,
      this.onNo});

  @override
  State<YNModal> createState() => _YNModalState();
}

class _YNModalState extends State<YNModal> {
  RxBool isLoading = false.obs;

  void _handleYes() async {
    try {
      isLoading.value = true;
      await widget.onYes(true);
      Get.back();
    } catch (e) {
      print('Error in onYes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _handleNo() {
    widget.onNo?.call(false);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.4),
      body: Center(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Text(widget.content),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(() {
                      if (isLoading.value) {
                        return const CircularProgressIndicator(
                          color: AppColors.primary,
                        );
                      } else {
                        return Row(
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(40, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft,
                              ),
                              onPressed: isLoading.value ? null : _handleYes,
                              child: Text(widget.yesText),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(40, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft,
                              ),
                              onPressed: isLoading.value ? null : _handleNo,
                              child: Text(widget.noText),
                            ),
                          ],
                        );
                      }
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
