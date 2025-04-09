class WorkDayStaffModal {
  final String idWorkDay;
  final String workDate;
  final String startTime;
  final String endTime;

  WorkDayStaffModal({
    required this.idWorkDay,
    required this.workDate,
    required this.startTime,
    required this.endTime,
  });

  factory WorkDayStaffModal.fromJson(Map<String, dynamic> json) {
    return WorkDayStaffModal(
        idWorkDay: json['idWorkDay'] ?? '',
        workDate: json['workDate'] ?? '',
        startTime: json['startTime'] ?? '',
        endTime: json['endTime'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'idWorkDay': idWorkDay,
      'workDate': workDate,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
