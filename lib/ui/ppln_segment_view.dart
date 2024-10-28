import 'package:flutter/material.dart';
import 'package:bckgrnd/ppln/ppln_segment_status.dart';
import 'package:intl/intl.dart';
import 'package:bckgrnd/ui/ppln_segment_transcription_view.dart';
import 'package:bckgrnd/ui/common/ppln_segment_status_ext.dart';

class PplnSegmentView extends StatelessWidget {
  const PplnSegmentView({
    super.key,
    required this.segmentStatus,
  });

  final PplnSegmentStatus segmentStatus;

  @override
  Widget build(final BuildContext context) {
    switch (segmentStatus.state) {
      case PplnSegmentState.recording:
      case PplnSegmentState.recorded:
      case PplnSegmentState.transcribing:
        return _buildProcessingSegment(context, segmentStatus);
      case PplnSegmentState.transcribed:
        return PplnSegmentTranscriptionView(segmentStatus: segmentStatus);
      case PplnSegmentState.unknown:
    }
    return const SizedBox.shrink();
  }

  Widget _buildProcessingSegment(
      final BuildContext context, final PplnSegmentStatus segmentStatus) {
    final startTimeFormatted =
        DateFormat('HH:mm:ss').format(segmentStatus.recordStatus.startTime);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: segmentStatus.state.icon(Theme.of(context).colorScheme),
        title: Row(
          children: [
            Chip(
              label: Text(
                startTimeFormatted,
              ),
              backgroundColor: Theme.of(context).colorScheme.surfaceDim,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                segmentStatus.state.str,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
