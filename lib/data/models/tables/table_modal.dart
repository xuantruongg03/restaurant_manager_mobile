import 'package:restaurant_manager_mobile/utils/formats.dart';

class TableModel {
  final String idTable;
  final String name;
  final String status;
  final String time;
  bool isMerge;
  String color;

  TableModel({
    required this.idTable,
    required this.name,
    required this.status,
    required this.time,
    required this.isMerge,
    required this.color,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    DateTime now = DateTime.now();
    return TableModel(
      idTable: json['idTable'],
      name: json['nameTable'],
      status: json['status'],
      time: json['status'] == 'Available' ? 'Chưa có' : formatTime(now), 
      isMerge: json['mergedTo'] != null,
      color: '',
    );
  }
}
