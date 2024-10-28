import 'package:bckgrnd/ppln/ppln_segment_status.dart';

// TODO: store in db: mongo_dart
class PplnStatus {
  factory PplnStatus.fromJson(final Map<String, dynamic> json) {
    return PplnStatus(
      isRecording: json['isRecording'] as bool? ?? false,
      isProcessing: json['isProcessing'] as bool? ?? false,
      error: json['error'] as String?,
      segments: (json['segments'] as List<dynamic>?)
              ?.map((final e) => PplnSegmentStatus.fromJson(e))
              .toList() ??
          [],
    );
  }

  PplnStatus({
    required this.isRecording,
    required this.isProcessing,
    required this.segments,
    this.error,
  });

  final bool isRecording;
  final bool isProcessing;
  final List<PplnSegmentStatus> segments;
  final String? error;

  Map<String, dynamic> toJson() {
    return {
      'isRecording': isRecording,
      'isProcessing': isProcessing,
      'segments': segments.map((final e) => e.toJson()).toList(),
      'error': error,
    };
  }

  Map<String, dynamic> toPrettyJson() {
    return {
      'isRecording': isRecording,
      'isProcessing': isProcessing,
      'segments': segments.map((final e) => e.toPrettyJson()).toList(),
      'error': error,
    };
  }
}
