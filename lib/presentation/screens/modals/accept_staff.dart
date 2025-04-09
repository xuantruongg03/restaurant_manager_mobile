import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AcceptStaffModal extends StatefulWidget {
  final String name;
  final String phone;
  final String position;
  final String salary;
  final String actionType;

  const AcceptStaffModal(
      {super.key,
      required this.name,
      required this.phone,
      required this.position,
      required this.salary,
      required this.actionType});

  @override
  State<AcceptStaffModal> createState() => _AcceptStaffModalState();
}

class _AcceptStaffModalState extends State<AcceptStaffModal> {
  @override
  Widget build(BuildContext context) {
    final isCreate = widget.actionType == 'create';
    final title = isCreate ? 'Thành công' : 'Cập nhật thành công';
    final message = isCreate
        ? 'Tạo thành công nhân viên cho nhà hàng của bạn.'
        : 'Cập nhật thông tin nhân viên thành công.';

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(message),
                const SizedBox(height: 10),
                Text('Tài khoản: ${widget.name}'),
                Text('Số điện thoại: ${widget.phone}'),
                Text('Chức vụ: ${widget.position}'),
                Text('Lương: ${widget.salary}'),
                const SizedBox(height: 20),
                const Text(
                    '* Vui lòng đăng nhập và đổi mật khẩu để đảm bảo an toàn cho tài khoản.'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
