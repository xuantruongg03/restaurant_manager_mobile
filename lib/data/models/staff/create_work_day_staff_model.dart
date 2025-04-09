class CreateWorkDayStaffModel {
  final String username;
  final String dateOff;
  final String workDay;
  final String startTime;
  final String endTime;

  CreateWorkDayStaffModel({
    required this.username,
    required this.dateOff,
    required this.workDay,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'dateOffs': [dateOff],
      'workDays': [workDay],
      'timeStarts': [startTime],
      'timeEnds': [endTime],
    };
  }
}
