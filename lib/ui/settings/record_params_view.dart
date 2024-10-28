import 'package:flutter/material.dart';
import 'package:bckgrnd/ppln/record/record_params.dart';

class RecordParamsView extends StatelessWidget {
  const RecordParamsView({
    super.key,
    required this.params,
    required this.onChanged,
  });

  final RecordParams params;
  final ValueChanged<RecordParams> onChanged;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          _buildSlider(
            context: context,
            label: 'Sample Rate',
            value: params.sampleRate.toDouble(),
            min: 8000,
            max: 48000,
            divisions: 5,
            onChanged: (final value) {
              onChanged(params.copyWith(sampleRate: value.round()));
            },
          ),
          _buildSlider(
            context: context,
            label: 'Number of Channels',
            value: params.numChannels.toDouble(),
            min: 1,
            max: 2,
            divisions: 1,
            onChanged: (final value) {
              onChanged(params.copyWith(numChannels: value.round()));
            },
          ),
          _buildSwitch(
            context: context,
            label: 'Auto Gain',
            value: params.autoGain,
            onChanged: (final value) {
              onChanged(params.copyWith(autoGain: value));
            },
          ),
          _buildSwitch(
            context: context,
            label: 'Echo Cancel',
            value: params.echoCancel,
            onChanged: (final value) {
              onChanged(params.copyWith(echoCancel: value));
            },
          ),
          _buildSwitch(
            context: context,
            label: 'Noise Suppress',
            value: params.noiseSuppress,
            onChanged: (final value) {
              onChanged(params.copyWith(noiseSuppress: value));
            },
          ),
          _buildSlider(
            context: context,
            label: 'Max Chunk Duration (seconds)',
            value: params.maxChunkDuration.inSeconds.toDouble(),
            min: 10,
            max: 120,
            divisions: 11,
            onChanged: (final value) {
              onChanged(params.copyWith(
                  maxChunkDuration: Duration(seconds: value.round())));
            },
          ),
          _buildSlider(
            context: context,
            label: 'VAD Threshold',
            value: params.vadAmplitudeThresholdDb,
            min: -60,
            max: -10,
            divisions: 50,
            onChanged: (final value) {
              onChanged(params.copyWith(vadAmplitudeThresholdDb: value));
            },
          ),
          _buildSlider(
            context: context,
            label: 'VAD Interval (milliseconds)',
            value: params.vadMeasurePeriodMs.inMilliseconds.toDouble(),
            min: 100,
            max: 500,
            divisions: 8,
            onChanged: (final value) {
              onChanged(params.copyWith(
                  vadMeasurePeriodMs: Duration(milliseconds: value.round())));
            },
          ),
          _buildSlider(
            context: context,
            label: 'Speech to Silence Duration (seconds)',
            value:
                params.speechToSilenceDurationThresholdSec.inSeconds.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: (final value) {
              onChanged(params.copyWith(
                  speechToSilenceDurationThresholdSec:
                      Duration(seconds: value.round())));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required final BuildContext context,
    required final String label,
    required final double value,
    required final double min,
    required final double max,
    required final int divisions,
    required final ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged,
              ),
            ),
            Text(
              value.toStringAsFixed(1),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSwitch({
    required final BuildContext context,
    required final String label,
    required final bool value,
    required final ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}
