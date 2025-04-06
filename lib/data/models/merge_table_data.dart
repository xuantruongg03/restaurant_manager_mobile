class MergeTableData {
  final String table1;
  final String table2;
  final String color;

  MergeTableData({
    required this.table1,
    required this.table2,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'table1': table1,
      'table2': table2,
      'color': color,
    };
  }

  static MergeTableData fromJson(Map<String, dynamic> json) { 
    return MergeTableData(
      table1: json['table1'],
      table2: json['table2'],
      color: json['color'],
    );
  }
} 