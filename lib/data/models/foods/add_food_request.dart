class AddFoodRequest {
  final String idMenu;
  final String name;
  final String category;
  final double price;
  final List<String> images;

  AddFoodRequest({
    required this.idMenu,
    required this.name,
    required this.category,
    required this.price,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'images': images,
    };
  }
}
