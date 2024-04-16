import 'package:intl/intl.dart';

String formatDateToDDMMYYYYHHMMString(String dateString) {
  if (dateString == "" || dateString.isEmpty||dateString=="null") return '';

  // Parse the string to DateTime object
  DateTime date = DateTime.parse(dateString);

  // Define the desired date format
  final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');

  // Format the date according to the defined format
  final String formattedDate = formatter.format(date);

  return formattedDate;
}
