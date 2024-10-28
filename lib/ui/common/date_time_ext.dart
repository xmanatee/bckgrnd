import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String get prettyString {
    return DateFormat('HH:mm:ss').format(this);
  }
}

extension DurationExt on Duration {
  // TODO: better formatting.
  String get prettyString {
    String twoDigits(final int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(inHours);
    final minutes = twoDigits(inMinutes.remainder(60));
    final seconds = twoDigits(inSeconds.remainder(60));

    return (inHours == 0 ? '' : '${hours}h') +
        (inMinutes == 0 ? '' : '${minutes}m') +
        (inSeconds == 0 ? '' : '${seconds}s');
  }
}

String formatDateTimePeriod(
    final DateTime? startTime, final DateTime? stopTime) {
  final startTimeStr = startTime?.prettyString ?? '';
  final stopTimeStr = stopTime?.prettyString ?? '';
  return '$startTimeStr - $stopTimeStr';
}

String formatDurationPeriod(
    final Duration? startTime, final Duration? stopTime) {
  final startTimeStr = startTime?.prettyString ?? '';
  final stopTimeStr = stopTime?.prettyString ?? '';
  return '$startTimeStr - $stopTimeStr';
}
