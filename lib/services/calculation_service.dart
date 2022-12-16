class Calculations {
  int getBerichtNr(DateTime start, DateTime now) {
    DateTime mondayStart =
        DateTime(start.year, start.month, start.day - start.weekday % 7);
    DateTime mondayNow =
        DateTime(now.year, now.month, now.day - now.weekday % 7);

    var datedif =
        mondayNow.millisecondsSinceEpoch - mondayStart.millisecondsSinceEpoch;

    return (Duration(milliseconds: datedif).inDays ~/ 7) + 1;
  }
}
