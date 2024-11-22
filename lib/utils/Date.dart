import 'package:intl/intl.dart';

class Date {
  static DateTime currentDate() => DateTime.now();
  static String dayOfWeek(DateTime date) =>
      DateFormat.E().format(date);
  static String day(DateTime date) => DateFormat.d().format(date);
  static String month(DateTime date) =>
      DateFormat.MMM().format(date);
  static String fullmonth(DateTime date) =>
      DateFormat.MMMM().format(date);
  static String hour(DateTime date) => DateFormat.jm().format(date);
  static String year(DateTime date) => DateFormat.y().format(date);

  static String fullTime(DateTime date) =>
      DateFormat.jm().format(date);

  static String time(DateTime date) =>
      DateFormat('hh:mm a', ).format(date);

  static DateTime convert(String date) {
    return DateTime.parse(date);
  }

  static DateFormat fmYMD() => DateFormat('yyyy-MM-dd', );
  static DateFormat fmMDY() => DateFormat('MMM d, yyyy', );

  static tzToDateTime(String tz) {
    String date = DateTime.parse(tz).toLocal().toString();
    String huyDate = DateFormat("MMM dd, yyyy hh:mm a", ).format(
      DateTime.parse(date),
    );
    return huyDate;
  }

  static String dateTime(DateTime date) {
    DateFormat inputFormat = DateFormat('d/MMM/yyyy hh:mm a', );
    return inputFormat.format(date);
  }



  static String date(DateTime date, {String between = '/'}) {
    return '${day(date)}$between${month(date)}$between${year(date)}';
  }
}
