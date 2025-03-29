class AddTableRequest {
  final String tableName;
  final String idRestaurant;

  AddTableRequest({
    required this.tableName,
    required this.idRestaurant,
  });

  Map<String, Object> toJson() {
    return {
      'nameTable': tableName,
      'idRestaurant': idRestaurant,
    };
  }
}