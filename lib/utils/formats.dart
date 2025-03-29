import 'package:intl/intl.dart';

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
  return fullName
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
