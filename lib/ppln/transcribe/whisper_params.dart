import 'package:whisper_flutter_new/whisper_flutter_new.dart';

class WhisperParams {

  factory WhisperParams.fromJson(final Map<String, dynamic> json) {
    return WhisperParams(
      model: stringToModel(json['model'] as String),
      lang: json['lang'] as String,
      translate: json['translate'] as bool,
      withSegments: json['withSegments'] as bool,
      splitWords: json['splitWords'] as bool,
      diarize: json['diarize'] as bool,
      speedUp: json['speedUp'] as bool,
    );
  }
  WhisperParams({
    this.model = WhisperModel.tiny,
    this.lang = 'auto',
    this.translate = false,
    this.withSegments = false,
    this.splitWords = false,
    this.diarize = false,
    this.speedUp = false,
  });

  final WhisperModel model;
  final String lang;
  final bool translate;
  final bool withSegments;
  final bool splitWords;
  final bool diarize;
  final bool speedUp;

  WhisperParams copyWith({
    final WhisperModel? model,
    final String? lang,
    final bool? translate,
    final bool? withSegments,
    final bool? splitWords,
    final bool? diarize,
    final bool? speedUp,
  }) {
    return WhisperParams(
      model: model ?? this.model,
      lang: lang ?? this.lang,
      translate: translate ?? this.translate,
      withSegments: withSegments ?? this.withSegments,
      splitWords: splitWords ?? this.splitWords,
      diarize: diarize ?? this.diarize,
      speedUp: speedUp ?? this.speedUp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': modelToString(model),
      'lang': lang,
      'translate': translate,
      'withSegments': withSegments,
      'splitWords': splitWords,
      'diarize': diarize,
      'speedUp': speedUp,
    };
  }

  static String modelToString(final WhisperModel model) {
    // Convert WhisperModel to a string representation
    return model.name;
  }

  static WhisperModel stringToModel(final String modelName) {
    // Convert string back to WhisperModel
    switch (modelName) {
      case 'tiny':
        return WhisperModel.tiny;
      case 'base':
        return WhisperModel.base;
      case 'small':
        return WhisperModel.small;
      case 'medium':
        return WhisperModel.medium;
      case 'large-v1':
        return WhisperModel.largeV1;
      case 'large-v2':
        return WhisperModel.largeV2;
      default:
        return WhisperModel.none;
    }
  }
}
