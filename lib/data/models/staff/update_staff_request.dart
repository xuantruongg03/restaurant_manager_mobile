class UpdateStaffRequest {
  final String name;
  final String phone;
  final String role;
  final String salary;
  final String type;
  final String bankNumber;
  final String bankName;

  UpdateStaffRequest({
    required this.name,
    required this.phone,
    required this.role,
    required this.salary,
    required this.type,
    required this.bankNumber,
    required this.bankName,
  });

  Map<String, Object> toJson() {
    return {
      'name': name,
      'phone': phone,
      'role': role,
      'salary': salary,
      'type': type,
      'bankNumber': bankNumber,
      'bankName': bankName,
    };
  }

  @override
  String toString() {
    return 'AddStaffRequest('
        'name: $name, '
        'phone: $phone, '
        'role: $role, '
        'salary: $salary, '
        'type: $type, '
        'bankNumber: $bankNumber, '
        'bankName: $bankName'
        ')';
  }
}
