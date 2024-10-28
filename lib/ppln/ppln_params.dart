import 'package:bckgrnd/ppln/record/record_params.dart';
import 'package:bckgrnd/ppln/transcribe/whisper_params.dart';

class PplnParams {
  factory PplnParams.fromJson(final Map<String, dynamic> json) {
    return PplnParams(
      recordParams:
          RecordParams.fromJson(json['recordParams'] as Map<String, dynamic>),
      whisperParams:
          WhisperParams.fromJson(json['whisperParams'] as Map<String, dynamic>),
    );
  }
  PplnParams({
    final RecordParams? recordParams,
    final WhisperParams? whisperParams,
  })  : recordParams = recordParams ?? RecordParams(),
        whisperParams = whisperParams ?? WhisperParams();

  final RecordParams recordParams;
  final WhisperParams whisperParams;

  Map<String, dynamic> toJson() {
    return {
      'recordParams': recordParams.toJson(),
      'whisperParams': whisperParams.toJson(),
    };
  }

  PplnParams copyWith({
    final RecordParams? recordParams,
    final WhisperParams? whisperParams,
  }) {
    return PplnParams(
      recordParams: recordParams ?? this.recordParams,
      whisperParams: whisperParams ?? this.whisperParams,
    );
  }
}
