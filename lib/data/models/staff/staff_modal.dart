class StaffModel {
  final String userId;
  final String name;
  final String role;
  final int shifts;
  final int baseSalary;
  final String username;
  final int payment;
  final String type;
  final String bankAccountNumber;
  final String bank;
  final String workStartDate;

  StaffModel({
    required this.userId,
    required this.name,
    required this.role,
    required this.shifts,
    required this.baseSalary,
    required this.username,
    required this.payment,
    required this.type,
    required this.bankAccountNumber,
    required this.bank,
    required this.workStartDate,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      userId: json['userId'],
      name: json['name'],
      role: json['role'],
      shifts: json['shifts'],
      baseSalary: json['baseSalary'],
      username: json['username'],
      payment: json['payment'],
      type: json['type'],
      bankAccountNumber: json['bankAccountNumber'],
      bank: json['bank'],
      workStartDate: json['workStartDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
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
}
