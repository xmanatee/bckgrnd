import 'package:bckgrnd/ui/time_period_view.dart';
import 'package:flutter/material.dart';
import 'package:bckgrnd/ppln/ppln_segment_status.dart';
import 'package:intl/intl.dart';
import 'package:bckgrnd/ui/common/ppln_segment_status_ext.dart';

// TODO: add play button for recordings
class PplnSegmentTranscriptionView extends StatelessWidget {
  const PplnSegmentTranscriptionView({
    super.key,
    required this.segmentStatus,
  });

  final PplnSegmentStatus segmentStatus;

  @override
  Widget build(final BuildContext context) {
    // Formatting times
    final recordStartFormatted =
        DateFormat('HH:mm:ss').format(segmentStatus.recordStatus.startTime);

    // Transcription details
    final transcriptionText =
        segmentStatus.transcribeStatus!.transcription!.text;
    final transcriptionSegments =
        segmentStatus.transcribeStatus!.transcription!.segments;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        leading: segmentStatus.state.icon(Theme.of(context).colorScheme),
        title: Row(
          children: [
            Chip(
              label: Text(
                recordStartFormatted,
              ),
              backgroundColor: Theme.of(context).colorScheme.surfaceDim,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                transcriptionText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TimePeriodView(
                  title: 'Recording',
                  startTime: segmentStatus.recordStatus.startTime,
                  stopTime: segmentStatus.recordStatus.stopTime,
                  duration: segmentStatus.recordStatus.duration,
                ),
                TimePeriodView(
                  title: 'Transcription',
                  startTime: segmentStatus.transcribeStatus?.startTime,
                  stopTime: segmentStatus.transcribeStatus?.stopTime,
                  duration: segmentStatus.transcribeStatus?.duration,
                ),
                const SizedBox(height: 12),

                // Full Transcription Text
                Text(
                  'Full Transcription:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  transcriptionText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),

                // Transcription Segments
                if (transcriptionSegments != null &&
                    transcriptionSegments.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Segments:',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: transcriptionSegments
                            .map(
                              (final segment) => Chip(
                                label: Text(
                                  '[${segment.fromTs.inSeconds} - ${segment.toTs.inSeconds}] ${segment.text}',
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
