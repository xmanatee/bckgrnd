import 'dart:async';

import 'package:record/record.dart';

class RecordVad {
  RecordVad({
    required this.vadAmplitudeThresholdDb,
    required this.vadMeasurePeriodMs,
    required this.speechToSilenceDurationThresholdSec,
    required this.onSilence,
  });

  final double vadAmplitudeThresholdDb;
  final Duration vadMeasurePeriodMs;
  final Duration speechToSilenceDurationThresholdSec;

  final Future<void> Function() onSilence;

  StreamSubscription<Amplitude>? _amplitudeSubscription;
  DateTime? silenceStartedTime;
  bool _silenceNotified = true;

  void start(final AudioRecorder record) {
    _amplitudeSubscription =
        record.onAmplitudeChanged(vadMeasurePeriodMs).listen(_processAmplitude);
    silenceStartedTime = null;
    _silenceNotified = true;
  }

  Future<void> stop() async {
    await _amplitudeSubscription?.cancel();
    _amplitudeSubscription = null;
  }

  Future<void> _processAmplitude(final Amplitude amplitude) async {
    if (amplitude.current > vadAmplitudeThresholdDb) {
      silenceStartedTime = null;
      _silenceNotified = false;
    } else {
      final now = DateTime.now();
      silenceStartedTime ??= now;

      if (!_silenceNotified &&
          silenceStartedTime!
              .add(speechToSilenceDurationThresholdSec)
              .isBefore(now)) {
        await onSilence();
        _silenceNotified = true;
      }
    }
  }
}
