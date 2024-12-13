class TableModel {
  final String idTable;
  final String name;
  final String status;
  final String time;
  final bool isMerge;

  TableModel({
    required this.idTable,
    required this.name,
    required this.status,
    required this.time,
    required this.isMerge,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      idTable: json['idTable'],
      name: json['tableName'],
      status: json['status'],
      time: "9h40",
      isMerge: false,
    );
  }
}
