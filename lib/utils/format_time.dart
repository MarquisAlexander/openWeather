String formatTime(int timestamp, int timezoneOffset) {
  final date = DateTime.fromMillisecondsSinceEpoch(
    (timestamp + timezoneOffset) * 1000,
    isUtc: true,
  );
  return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
}
