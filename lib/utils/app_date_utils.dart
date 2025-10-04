class AppDateUtils {

  static DateTime getCurrentDate() {
    return DateTime.now();
  }

  static int getCurrentYear() {
    return getCurrentDate().year;
  }

  static int getCurrentMonth() {
    return getCurrentDate().month;
  }
}