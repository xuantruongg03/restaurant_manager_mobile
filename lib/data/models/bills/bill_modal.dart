class Food {
  final String idFood;
  final String name;
  final double price;
  final String image;
  final int quantity;
  final String idOrder;
  final String paid;
  final String status;

  Food({
    required this.idFood,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    required this.idOrder,
    required this.paid,
    required this.status,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      idFood: json['idFood'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      quantity: json['quantity'],
      idOrder: json['idOrder'],
      paid: json['paid'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idFood': idFood,
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
      'idOrder': idOrder,
      'paid': paid,
      'status': status,
      };
  }
}

class BillModel {
  final String idTable;
  final String idBill;
  final String nameTable;
  List<Food> foods;
  final double total;
  final String status;

  BillModel({
    required this.idTable,
    required this.idBill,
    required this.nameTable,
    required this.foods,
    required this.total,
    required this.status,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    var foodList = json['foods'] as List;
    List<Food> foodItems = foodList.map((i) => Food.fromJson(i)).toList();

    return BillModel(
      idTable: json['idTable'],
      idBill: json['idBill'],
      nameTable: json['nameTable'],
      foods: foodItems,
      total: json['total'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTable': idTable,
      'idBill': idBill,
      'nameTable': nameTable,
      'foods': foods.map((f) => f.toJson()).toList(),
      'total': total,
      'status': status,
    };
  }
}
