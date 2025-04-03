class FoodRequest {
  final String idMenu;
  final String name;
  final double price;
  final String image;
  final String type;
  final String idFood;

  FoodRequest({
    required this.idFood,
    required this.idMenu,
    required this.name,
    required this.price,
    required this.image,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'idFood': idFood,
      'name': name,
      'image': image,
      'price': price,
      'idMenu': idMenu,
      'type': type,
    };
  }
}
