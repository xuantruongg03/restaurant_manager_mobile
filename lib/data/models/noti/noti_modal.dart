import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/utils/functions.dart';

class NotiModal {
  final String id;
  final String title;
  final String content;
  final String time;
  final RxBool isRead;
  final String date;

  NotiModal({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    required this.isRead,
    required this.date,
  });

  factory NotiModal.fromJson(Map<String, dynamic> json) {
  return NotiModal(
    id: Functions.generateRandomString(10),
    title: json['title'],
    content: json['content'],
    time: json['time'],
    isRead: (json['isRead'] as bool).obs, // Chuyển đổi bool thành RxBool
    date: json['date'],
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'time': time,
      'isRead': isRead.value,
      'date': date,
    };
  }
}
