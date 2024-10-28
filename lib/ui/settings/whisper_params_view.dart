import 'package:bckgrnd/ppln/transcribe/whisper_params.dart';
import 'package:flutter/material.dart';
import 'package:whisper_flutter_new/whisper_flutter_new.dart';

class WhisperParamsView extends StatelessWidget {
  const WhisperParamsView({
    super.key,
    required this.params,
    required this.onChanged,
  });

  final WhisperParams params;
  final ValueChanged<WhisperParams> onChanged;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          _buildDropdown<WhisperModel>(
            context: context,
            label: 'Model',
            value: params.model,
            items: WhisperModel.values
                .where((final m) => m.modelName.isNotEmpty)
                .map((final WhisperModel model) =>
                    DropdownMenuItem<WhisperModel>(
                      value: model,
                      child: Text(model.modelName),
                    ))
                .toList(),
            onChanged: (final WhisperModel? newModel) {
              if (newModel != null) {
                onChanged(params.copyWith(model: newModel));
              }
            },
          ),
          const SizedBox(height: 16),
          _buildDropdown<String>(
            context: context,
            label: 'Language',
            value: params.lang,
            items: ['auto', 'zh', 'en']
                .map((final String lang) => DropdownMenuItem<String>(
                      value: lang,
                      child: Text(lang.toUpperCase()),
                    ))
                .toList(),
            onChanged: (final String? newLang) {
              if (newLang != null) {
                onChanged(params.copyWith(lang: newLang));
              }
            },
          ),
          const SizedBox(height: 16),
          _buildSwitch(
            context: context,
            label: 'Translate',
            value: params.translate,
            onChanged: (final bool newValue) {
              onChanged(params.copyWith(translate: newValue));
            },
          ),
          _buildSwitch(
            context: context,
            label: 'With Segments',
            value: params.withSegments,
            onChanged: (final bool newValue) {
              onChanged(params.copyWith(withSegments: newValue));
            },
          ),
          _buildSwitch(
            context: context,
            label: 'Split Words',
            value: params.splitWords,
            onChanged: (final bool newValue) {
              onChanged(params.copyWith(splitWords: newValue));
            },
          ),
          _buildSwitch(
            context: context,
            label: 'Diarize',
            value: params.diarize,
            onChanged: (final bool newValue) {
              onChanged(params.copyWith(diarize: newValue));
            },
          ),
          _buildSwitch(
            context: context,
            label: 'Speed Up',
            value: params.speedUp,
            onChanged: (final bool newValue) {
              onChanged(params.copyWith(speedUp: newValue));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required final BuildContext context,
    required final String label,
    required final T value,
    required final List<DropdownMenuItem<T>> items,
    required final ValueChanged<T?> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          style: Theme.of(context).textTheme.bodyMedium,
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
      activeColor: Theme.of(context).colorScheme.primary,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}
