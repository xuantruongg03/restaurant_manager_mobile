class AddStaffRequest {
  final String username;
  final String password;
  final String name;
  final String phone;
  final String role;
  final String idRestaurant;
  final String salary;
  final String type;
  final String bankNumber;
  final String bankName;

  AddStaffRequest({
    required this.username,
    required this.password,
    required this.name,
    required this.phone,
    required this.role,
    required this.idRestaurant,
    required this.salary,
    required this.type,
    required this.bankNumber,
    required this.bankName,
  });

  Map<String, Object> toJson() {
    return {
      'username': username,
      'password': password,
      'name': name,
      'phone': phone,
      'role': role,
      'idRestaurant': idRestaurant,
      'salary': salary,
      'type': type,
      'bankNumber': bankNumber,
      'bankName': bankName,
    };
  }
}
