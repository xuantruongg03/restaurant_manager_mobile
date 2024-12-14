class FoodRequest {
  final String idMenu;
  final String name;
  final String category;
  final double price;
  // final List<String> images;
  final String image;

  FoodRequest({
    required this.idMenu,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      // 'category': category,
      'image': image,
      'price': price,
      'idMenu': idMenu,
    };
  }
}
