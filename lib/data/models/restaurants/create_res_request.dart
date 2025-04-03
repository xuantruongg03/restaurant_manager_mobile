class CreateRestaurantRequest {
  final String name;
  final String idAccount;

  CreateRestaurantRequest({
    required this.name,
    required this.idAccount,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'idAccount': idAccount,
    };
  }
}
