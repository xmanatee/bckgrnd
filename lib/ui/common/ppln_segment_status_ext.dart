import 'package:flutter/material.dart';
import 'package:bckgrnd/ppln/ppln_segment_status.dart';

extension PplnSegmentStateExtension on PplnSegmentState {
  String get str {
    switch (this) {
      case PplnSegmentState.recording:
        return 'Recording';
      case PplnSegmentState.recorded:
        return 'Queued';
      case PplnSegmentState.transcribing:
        return 'Processing';
      case PplnSegmentState.transcribed:
        return 'Transcribed';
      case PplnSegmentState.unknown:
        return 'Unknown';
    }
  }

  Icon icon(final ColorScheme colorScheme) {
    switch (this) {
      case PplnSegmentState.recording:
        return Icon(
          Icons.mic_rounded,
          color: colorScheme.primary,
        );
      case PplnSegmentState.recorded:
        return Icon(
          Icons.queue_rounded,
          color: colorScheme.secondary,
        );
      case PplnSegmentState.transcribing:
        return Icon(
          Icons.sync_alt_rounded,
          color: colorScheme.onSurface,
        );
      case PplnSegmentState.transcribed:
        return const Icon(
          Icons.done_rounded,
          color: Colors.green,
        );
      case PplnSegmentState.unknown:
        return Icon(
          Icons.error_rounded,
          color: colorScheme.error,
        );
    }
  }
}
