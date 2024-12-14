class FoodModel {
  final String idFood;
  final String name;
  final double price;
  final String image;
  final String category;
  final String? type;

  FoodModel({
    required this.idFood,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
     this.type,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      idFood: json['idFood'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      category: "Đồ ăn",
      type: "Chiên",
    );
  }
}
