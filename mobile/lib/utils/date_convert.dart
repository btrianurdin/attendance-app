import 'package:intl/intl.dart';

String formatDateID(String pattern, String? dateStr) {
  if (dateStr == null) return "-";
  final date =
      DateFormat(pattern, "id").format(DateTime.parse(dateStr).toLocal());

  return date;
}

String parseUtcToLocal({
  String utcPattern = 'y-M-d H:m:s',
  required String pattern,
  String? date,
}) {
  if (date == null) return '-';
  final dateUtc = DateFormat(utcPattern).parseUTC(date).toLocal();
  final dateLocal = DateFormat(pattern, 'id').format(dateUtc);

  return dateLocal;
}

String timeHm(String? time) {
  if (time == null) return '-';
  return time.substring(0, time.length - 3);
}

String timeParseHm(String? utcTime) {
  if (utcTime == null) return '-';
  DateTime dateTimeUtc = DateFormat.Hms().parseUTC(utcTime).toLocal();

  return DateFormat.Hm().format(dateTimeUtc);
}
