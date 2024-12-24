class StatisticModel {
  final String id;
  final String date;
  final int totalOrder;
  final int totalRevenue;

  StatisticModel({
    required this.id,
    required this.date,
    required this.totalOrder,
    required this.totalRevenue,
  });

  factory StatisticModel.fromJson(Map<String, dynamic> json) {
    return StatisticModel(
      id: json['id'],
      date: json['date'],
      totalOrder: json['totalOrder'],
      totalRevenue: json['totalRevenue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'totalOrder': totalOrder,
      'totalRevenue': totalRevenue,
    };
  }
}