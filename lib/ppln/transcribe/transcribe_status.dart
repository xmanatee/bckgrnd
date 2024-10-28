import 'package:whisper_flutter_new/whisper_flutter_new.dart';

class TranscribeStatus {
  factory TranscribeStatus.fromJson(final Map<String, dynamic> json) {
    return TranscribeStatus._(
      startTime: DateTime.parse(json['startTime'] as String),
      stopTime: json['stopTime'] != null
          ? DateTime.parse(json['stopTime'] as String)
          : null,
      transcription: json['stopTime'] != null
          ? WhisperTranscribeResponse.fromJson(
              json['transcription'] as Map<String, dynamic>,
            )
          : null,
    );
  }
  factory TranscribeStatus.started() {
    return TranscribeStatus._(startTime: DateTime.now());
  }

  TranscribeStatus._({
    required this.startTime,
    this.stopTime,
    this.transcription,
  });

  final DateTime startTime;
  final DateTime? stopTime;
  final WhisperTranscribeResponse? transcription;

  Duration? get duration => stopTime?.difference(startTime);

  TranscribeStatus finished(final WhisperTranscribeResponse transcription) {
    return TranscribeStatus._(
      startTime: startTime,
      stopTime: DateTime.now(),
      transcription: transcription,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'transcription': transcription?.toJson(),
      'stopTime': stopTime?.toIso8601String(),
    };
  }
}
