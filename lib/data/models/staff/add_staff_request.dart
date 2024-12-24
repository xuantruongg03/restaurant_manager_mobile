class AddStaffRequest {
  final String idRestaurant;
  final String name;
  final String phone;
  final String position;
  final String salaryType;
  final String salary;

  AddStaffRequest({
    required this.idRestaurant,
    required this.name,
    required this.phone,
    required this.position,
    required this.salaryType,
    required this.salary,
  });

  Map<String, Object> toJson() {
    return {
      'name': name,
      'idRestaurant': idRestaurant,
      'phone': phone,
      'position': position,
      'salaryType': salaryType,
      'salary': salary,
    };
  }
}
