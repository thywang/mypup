class CalculateTimeBetween {
  static int weeksBetween(DateTime from, DateTime to) {
    final days = daysBetween(from, to);
    final weeks = days ~/ 7;
    return weeks;
  }

  static int daysBetween(DateTime from, DateTime to) {
    final dateFrom = DateTime(from.year, from.month, from.day);
    final dateto = DateTime(to.year, to.month, to.day);
    final days = (dateto.difference(dateFrom).inHours / 24).round();
    return days;
  }

  static List<int> monthsWeeksDaysSince(DateTime from) {
    final to = DateTime.now();
    final days = daysBetween(from, to);

    final months = days ~/ 30.44;
    var daysRem = days.remainder(30.44).round();

    final weeks = daysRem ~/ 7;
    daysRem = daysRem.remainder(7);

    final res = [months, weeks, daysRem];
    return res;
  }
}
