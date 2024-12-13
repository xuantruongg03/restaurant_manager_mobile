class TableModel {
  final String idTable;
  final String name;
  final String status;

  TableModel({
    required this.idTable,
    required this.name,
    required this.status,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      idTable: json['idTable'],
      name: json['name'],
      status: json['status'],
    );
  }
}
