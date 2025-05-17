import 'package:intl/intl.dart';

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString).toLocal();
  final formatter = DateFormat("dd MMM yyyy");
  return formatter.format(dateTime);
}
