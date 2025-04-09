class CreateRestaurantRequest {
  final String name;
  final String idAccount;
  final String status;
  final bool isSelected;
  final String address;

  CreateRestaurantRequest({
    required this.name,
    required this.idAccount,
    required this.status,
    required this.isSelected,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'idAccount': idAccount,
      'address': address,
    };
  }
}
