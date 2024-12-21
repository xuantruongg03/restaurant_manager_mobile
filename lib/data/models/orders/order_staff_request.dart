class OrderStaffRequest {
  final String idFood;
  final String idTable;
  final num quantity;

  OrderStaffRequest({
    required this.idFood,
    required this.idTable,
    required this.quantity,
  });

  factory OrderStaffRequest.fromJson(Map<String, dynamic> json) {
    return OrderStaffRequest(
      idFood: json['idFood'],
      idTable: json['idTable'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idFood': idFood,
      'idTable': idTable,
      'quantity': quantity,
    };
  }
}
