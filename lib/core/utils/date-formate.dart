import 'package:intl/intl.dart';

String dateFormatByDMMMYYY(DateTime date) {
  return DateFormat("d MMM yyyy").format(date);
}
