class BillModel {
  final String idBill;
  final String idTable;
  final String idStaff;
  final String idCustomer;

  BillModel({
    required this.idBill,
    required this.idTable,
    required this.idStaff,
    required this.idCustomer,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      idBill: json['idBill'],
      idTable: json['idTable'],
      idStaff: json['idStaff'],
      idCustomer: json['idCustomer'],
    );
  }
}
