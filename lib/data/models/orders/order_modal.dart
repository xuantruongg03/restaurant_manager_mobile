class OrderModal {
  final String idFood;
  final String nameFood;
  final int quantity;
  final String nameTable;
  final String status;
  final String createdAt;
  final String image;
  final String idOrder;

  OrderModal({
    required this.idFood,
    required this.nameFood,
    required this.quantity,
    required this.nameTable,
    required this.status,
    required this.createdAt,
    required this.image,
    required this.idOrder,
  });

  factory OrderModal.fromJson(Map<String, dynamic> json, String nameTable) {
    return OrderModal(
      idFood: json['idFood'],
      nameFood: json['name'],
      quantity: json['quantity'],
      nameTable: nameTable,
      status: "Xác nhận",
      createdAt: "10/10/2024",
      image: json['image'],
      idOrder: json['idOrder'],
    );
  }
}