import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessOrderModal extends StatefulWidget {
  final String orderId;
  final String nameFood;
  final num quantity;
  final String nameTable;
  final Function(String) onSuccess;

  const SuccessOrderModal(
      {super.key,
      required this.orderId,
      required this.nameFood,
      required this.quantity,
      required this.nameTable,
      required this.onSuccess});

  @override
  State<SuccessOrderModal> createState() => _SuccessOrderModalState();
}

class _SuccessOrderModalState extends State<SuccessOrderModal> {
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
                    const Text(
                      'Hoàn thành đơn hàng',
                      style: TextStyle(
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
                Text(
                  'Tên món: ${widget.nameFood}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Số lượng: ${widget.quantity}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Bàn: ${widget.nameTable}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    widget.onSuccess(widget.orderId);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text(
                    'Hoàn thành',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: Colors.orange),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Huỷ',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
