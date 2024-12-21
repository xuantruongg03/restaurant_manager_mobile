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
                    Flexible(
                      child: Column(
                        children: [
                          Obx(() => ElevatedButton(
                                onPressed: _handleYes,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  minimumSize: const Size(double.infinity, 48),
                                ),
                                child: isLoading.value
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        widget.yesText,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                              )),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: _handleNo,
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              side: const BorderSide(
                                  color: Colors.orange, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              widget.noText,
                              style: const TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ),
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
