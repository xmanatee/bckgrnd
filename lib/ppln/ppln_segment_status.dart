import 'package:isar/isar.dart';

import 'package:bckgrnd/ppln/record/record_status.dart';
import 'package:bckgrnd/ppln/transcribe/transcribe_status.dart';

enum PplnSegmentState {
  unknown,
  recording,
  recorded,
  transcribing,
  transcribed;
}

@collection
class PplnSegmentStatus {
  // TODO: use json_annotation package instead.
  factory PplnSegmentStatus.fromJson(final Map<String, dynamic> json) {
    return PplnSegmentStatus(
      recordStatus: RecordStatus.fromJson(json['recordStatus']),
      transcribeStatus: json['transcribeStatus'] != null
          ? TranscribeStatus.fromJson(json['transcribeStatus'])
          : null,
    );
  }
  factory PplnSegmentStatus.fromRecord(final RecordStatus recordStatus) {
    return PplnSegmentStatus(
      recordStatus: recordStatus,
    );
  }

  PplnSegmentStatus({
    required this.recordStatus,
    this.transcribeStatus,
  });

  final RecordStatus recordStatus;
  final TranscribeStatus? transcribeStatus;

  int get id => recordStatus.id;
  String get key => id.toString();

  PplnSegmentState get state {
    if (recordStatus.stopTime == null) {
      return PplnSegmentState.recording;
    }

    if (transcribeStatus == null) {
      return PplnSegmentState.recorded;
    }
    if (transcribeStatus!.stopTime == null) {
      return PplnSegmentState.transcribing;
    }

    if (transcribeStatus!.stopTime != null) {
      return PplnSegmentState.transcribed;
    }

    return PplnSegmentState.unknown;
  }

  PplnSegmentStatus withTranscribeStatus(
      final TranscribeStatus transcribeStatus) {
    return PplnSegmentStatus(
      recordStatus: recordStatus,
      transcribeStatus: transcribeStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recordStatus': recordStatus.toJson(),
      'transcribeStatus': transcribeStatus?.toJson(),
    };
  }

  Map<String, dynamic> toPrettyJson() {
    return {
      'id': id,
      'state': state.name,
    };
  }
}
