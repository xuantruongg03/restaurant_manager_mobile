import 'package:flutter/material.dart';

class AcceptOrderModal extends StatefulWidget {
  final String orderId;
  final String nameFood;
  final String nameTable;
  final num quantity;

  const AcceptOrderModal(
      {super.key,
      required this.orderId,
      required this.nameFood,
      required this.quantity,
      required this.nameTable});

  @override
  State<AcceptOrderModal> createState() => _AcceptOrderModalState();
}

class _AcceptOrderModalState extends State<AcceptOrderModal> {
  @override
  void initState() {
    super.initState();
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
                    const Text(
                      'Xác nhận đơn hàng',
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
                 const Text(
                  'Không thể huỷ sau khi xác nhận',
                  style: TextStyle(fontSize: 16),
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text(
                    'Xác nhận',
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
