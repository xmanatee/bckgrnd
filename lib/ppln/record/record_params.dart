class RecordParams {
  factory RecordParams.fromJson(final Map<String, dynamic> json) {
    return RecordParams(
      sampleRate: json['sampleRate'] as int,
      numChannels: json['numChannels'] as int,
      autoGain: json['autoGain'] as bool,
      echoCancel: json['echoCancel'] as bool,
      noiseSuppress: json['noiseSuppress'] as bool,
      maxChunkDuration: Duration(seconds: json['maxChunkDuration'] as int),
      vadAmplitudeThresholdDb: json['vadAmplitudeThresholdDb'] is int
          ? (json['vadAmplitudeThresholdDb'] as int).toDouble()
          : json['vadAmplitudeThresholdDb'] as double,
      vadMeasurePeriodMs:
          Duration(milliseconds: json['vadMeasurePeriodMs'] as int),
      speechToSilenceDurationThresholdSec:
          Duration(seconds: json['speechToSilenceDurationThresholdSec'] as int),
    );
  }
  RecordParams({
    this.sampleRate = 16000,
    this.numChannels = 1,
    this.autoGain = true,
    this.echoCancel = true,
    this.noiseSuppress = true,
    this.maxChunkDuration = const Duration(seconds: 60),
    this.vadAmplitudeThresholdDb = -35.0,
    this.vadMeasurePeriodMs = const Duration(milliseconds: 200),
    this.speechToSilenceDurationThresholdSec = const Duration(seconds: 5),
  });

  final int sampleRate;
  final int numChannels;
  final bool autoGain;
  final bool echoCancel;
  final bool noiseSuppress;
  final Duration maxChunkDuration;
  final double vadAmplitudeThresholdDb;
  final Duration vadMeasurePeriodMs;
  final Duration speechToSilenceDurationThresholdSec;
  Map<String, dynamic> toJson() {
    return {
      'sampleRate': sampleRate,
      'numChannels': numChannels,
      'autoGain': autoGain,
      'echoCancel': echoCancel,
      'noiseSuppress': noiseSuppress,
      'maxChunkDuration': maxChunkDuration.inSeconds,
      'vadAmplitudeThresholdDb': vadAmplitudeThresholdDb,
      'vadMeasurePeriodMs': vadMeasurePeriodMs.inMilliseconds,
      'speechToSilenceDurationThresholdSec':
          speechToSilenceDurationThresholdSec.inSeconds,
    };
  }

  RecordParams copyWith({
    final int? sampleRate,
    final int? numChannels,
    final bool? autoGain,
    final bool? echoCancel,
    final bool? noiseSuppress,
    final Duration? maxChunkDuration,
    final double? vadAmplitudeThresholdDb,
    final Duration? vadMeasurePeriodMs,
    final Duration? speechToSilenceDurationThresholdSec,
  }) {
    return RecordParams(
      sampleRate: sampleRate ?? this.sampleRate,
      numChannels: numChannels ?? this.numChannels,
      autoGain: autoGain ?? this.autoGain,
      echoCancel: echoCancel ?? this.echoCancel,
      noiseSuppress: noiseSuppress ?? this.noiseSuppress,
      maxChunkDuration: maxChunkDuration ?? this.maxChunkDuration,
      vadAmplitudeThresholdDb:
          vadAmplitudeThresholdDb ?? this.vadAmplitudeThresholdDb,
      vadMeasurePeriodMs: vadMeasurePeriodMs ?? this.vadMeasurePeriodMs,
      speechToSilenceDurationThresholdSec:
          speechToSilenceDurationThresholdSec ??
              this.speechToSilenceDurationThresholdSec,
    );
  }
}
