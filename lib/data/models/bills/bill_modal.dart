class BillModel {
  final String idFood;
  final String nameFood;
  final String statusOrder;
  final int quantity;
  final String idBill;
  final String idTable;
  final String idStaff;
  final String idCustomer;
  final double total;

  BillModel({
    required this.idBill,
    required this.idTable,
    required this.idStaff,
    required this.idCustomer,
    required this.idFood,
    required this.nameFood,
    required this.statusOrder,
    required this.quantity,
    required this.total,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      idBill: json['idBill'],
      idTable: "",
      idStaff: "",
      idCustomer: "",
      idFood: json['idFood'],
      nameFood: json['name'],
      statusOrder: json['statusOrder'],
      quantity: json['quantity'] is String ? int.parse(json['quantity']) : json['quantity'],
      total: (json['price'] is String ? double.parse(json['price']) : json['price']) * 
             (json['quantity'] is String ? int.parse(json['quantity']) : json['quantity']),
    );
  }
}
