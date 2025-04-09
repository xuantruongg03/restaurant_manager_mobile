import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:restaurant_manager_mobile/utils/formats.dart';

class StaffModel {
  final String userId;
  final String name;
  final String phone;
  final String role;
  final double shifts;
  final double baseSalary;
  final String username;
  final int payment;
  final String type;
  final String bankAccountNumber;
  final String bank;
  final String workStartDate;
  RxBool isSelected; // Thêm RxBool để dễ cập nhật UI
  RxBool isExpanded;

  StaffModel({
    required this.userId,
    required this.name,
    required this.phone,
    required this.role,
    required this.shifts,
    required this.baseSalary,
    required this.username,
    required this.payment,
    required this.type,
    required this.bankAccountNumber,
    required this.bank,
    required this.workStartDate,
    bool isSelected = false, // Giá trị mặc định là false
    bool isExpanded = false, // Giá trị mặc định là false
  })  : isSelected = isSelected.obs, // Chuyển thành RxBool để cập nhật UI nhanh
        isExpanded = isExpanded.obs; // Khởi tạo RxBool

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
        userId: json['userId'] ?? '',
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        role: getRoleVN(json['role']),
        shifts: json['shifts'] ?? '',
        baseSalary: json['baseSalary'] ?? '',
        username: json['username'] ?? '',
        payment: json['payment'] ?? '',
        type: json['type'] ?? '',
        bankAccountNumber: json['bankAccountNumber'] ?? '',
        bank: json['bank'] ?? '',
        workStartDate: json['workStartDate'] != ''
            ? extractDate(json['workStartDate'])
            : '',
        isSelected: json['isSelected'] ?? false,
        isExpanded: json['isExpanded'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'phone': phone,
      'role': role,
      'shifts': shifts,
      'baseSalary': baseSalary,
      'username': username,
      'payment': payment,
      'type': type,
      'bankAccountNumber': bankAccountNumber,
      'bank': bank,
      'workStartDate': workStartDate,
    };
  }

  static String getRoleVN(String positionName) {
    if (positionName == 'Waiter') {
      return 'Phục vụ';
    } else if (positionName == 'Cook') {
      return 'Đầu bếp';
    } else if (positionName == 'Guard') {
      return 'Bảo vệ';
    } else {
      return 'Quản lý';
    }
  }

  static String getRoleEN(String positionName) {
    if (positionName == 'Phục vụ') {
      return 'Waiter';
    } else if (positionName == 'Đầu bếp') {
      return 'Cook';
    } else if (positionName == 'Bảo vệ') {
      return 'Guard';
    } else {
      return 'Manager';
    }
  }
}
