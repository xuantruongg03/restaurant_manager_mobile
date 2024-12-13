class FoodModel {
  final String name;
  final String price;
  final String description;

  FoodModel({
    required this.name,
    required this.price,
    required this.description,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      name: json['name'],
      price: json['price'],
      description: json['description'],
    );
  }
}
