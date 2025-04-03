class AddMenuRequest {
  final String name;
  final String idRestaurant;

  AddMenuRequest({required this.name, required this.idRestaurant});

    Map<String, Object> toJson() {
    return {
      'name': name,
      'idRestaurant': idRestaurant,
      'idMenu': '',
      'status': '',
    };
  }
}
