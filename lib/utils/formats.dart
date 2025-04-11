import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:diacritic/diacritic.dart';

/// Formats a number to include thousand separators
/// Example: 180000 -> 180,000
String formatMoney(num amount) {
  final formatter = NumberFormat('#,###');
  return formatter.format(amount);
}

/// Formats a number to currency with VND
/// Example: 180000 -> 180,000 VNĐ
String formatMoneyWithCurrency(num amount) {
  return '${formatMoney(amount)} VNĐ';
}

String formatMoneyWithCurrencyNotVND(num amount) {
  return formatMoney(amount);
}

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String convertFullNameToUsername(String fullName) {
  return removeDiacritics(fullName) // Xóa dấu
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), '');
}

String extractDate(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  return DateFormat('dd/MM/yyyy').format(dateTime);
}

String formatTime(DateTime time) {
  return DateFormat('HH:mm').format(time);
}

String convertDateToYMD(String dateString) {
  final date = DateFormat('dd/MM/yyyy').parse(dateString);
  return DateFormat('yyyy-MM-dd').format(date);
}

String convertDateTimeToYMD(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String formatWorkDate(String rawDateTime) {
  final dateTime = DateTime.parse(rawDateTime).toLocal();
  return DateFormat('dd/MM/yyyy').format(dateTime);
}

// String formatWorkTime(String rawTime) {
//   final parts = rawTime.split(':');
//   return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
// }

String formatWorkTime(String rawTime) {
  final parts = rawTime.split(':');
  if (parts.length >= 2) {
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  } else {
    return 'Giờ không hợp lệ';
  }
}

String convertTimeOfDayToString(TimeOfDay time) {
  final now = DateTime.now();
  final dateTime =
      DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat('HH:mm:ss').format(dateTime);
}

TimeOfDay parseTimeStringToTimeOfDay(String timeString) {
  final parts = timeString.split(":");
  return TimeOfDay(
    hour: int.parse(parts[0]),
    minute: int.parse(parts[1]),
  );
}
