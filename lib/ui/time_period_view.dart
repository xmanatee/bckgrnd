import 'package:bckgrnd/ui/common/date_time_ext.dart';
import 'package:flutter/material.dart';

class TimePeriodView extends StatelessWidget {
  const TimePeriodView({
    super.key,
    required this.title,
    this.startTime,
    this.stopTime,
    this.duration,
  });

  final String title;

  final DateTime? startTime;

  final DateTime? stopTime;

  final Duration? duration;

  @override
  Widget build(final BuildContext context) {
    final timePeriod = formatDateTimePeriod(startTime, stopTime);

    final durationString = "(${duration?.prettyString ?? "?"})";

    return Row(
      children: [
        _getIconForTitle(title),
        const SizedBox(width: 4),
        Text(
          '$title:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(timePeriod,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              ...[
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    durationString,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }

  Widget _getIconForTitle(final String title) {
    switch (title.toLowerCase()) {
      case 'recording':
        return const Icon(
          Icons.mic,
          size: 16,
        );
      case 'transcription':
        return const Icon(
          Icons.text_snippet,
          size: 16,
        );
      default:
        return const Icon(
          Icons.info,
          size: 16,
        );
    }
  }
}
